import datetime
import threading
from flask import Flask, request, jsonify
import requests
from transformers import AutoTokenizer, AutoModelForQuestionAnswering
from sentence_transformers import SentenceTransformer
import pandas as pd
import torch
from flask_cors import CORS
import base64
import os
import traceback
import re
from flask_mysqldb import MySQL
from config import Config
from werkzeug.utils import secure_filename
from werkzeug.security import check_password_hash  # if you're using hashed passwords
import base64

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)

# MySQL Initialization
mysql = MySQL(app)
with app.app_context():
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT 1")
        print("✅ Successfully connected to the MySQL database!")
        cur.close()
    except Exception as e:
        print("❌ Failed to connect to the MySQL database:", e)

# Load tokenizer and model
# tokenizer = AutoTokenizer.from_pretrained("tokenizer")
# model = AutoModelForQuestionAnswering.from_pretrained("model")
# embedding_model = SentenceTransformer("paraphrase-MiniLM-L6-v2")

# # Load Q&A dataset
# df = pd.read_excel("autism_faqs.xlsx")
# questions = df["Question"].fillna("").tolist()
# answers = df["Answer"].fillna("").tolist()
# question_embeddings = embedding_model.encode(questions, convert_to_tensor=True)

# Global variables for model and data
tokenizer = None
model = None
embedding_model = None
question_embeddings = None
questions = None
answers = None
models_loaded = threading.Event()

def initialize_models_and_data():
    global tokenizer, model, embedding_model, question_embeddings, questions, answers
    print("Loading models and data in background...")
    try:
        tokenizer = AutoTokenizer.from_pretrained("tokenizer")
        model = AutoModelForQuestionAnswering.from_pretrained("model")
        embedding_model = SentenceTransformer("paraphrase-MiniLM-L6-v2")
        
        # Load Q&A dataset
        df = pd.read_excel("autism_faqs.xlsx")
        questions = df["Question"].fillna("").tolist()
        answers = df["Answer"].fillna("").tolist()
        question_embeddings = embedding_model.encode(questions, convert_to_tensor=True)
        print("Models and data loaded successfully!")
    except Exception as e:
        print(f"Error loading models and data: {e}")
    finally:
        models_loaded.set()

# Start model loading in a background thread
with app.app_context():
    threading.Thread(target=initialize_models_and_data, daemon=True).start()




# # Define CARS categories
CARS_CATEGORIES = [
    "Relationship with others", "Imitation skills", "Emotional responses", "Body usage",
    "Object usage", "Adaptation to change", "Visual response", "Auditory response",
    "Taste, smell, and tactile response", "Anxiety and fear", "Verbal communication",
    "Non-verbal communication", "Activity level", "Intellectual response", "General impressions"
]

@app.route("/chat", methods=["POST"])
def chat():

    # Wait for models to be loaded if not already
    if not models_loaded.is_set():
        print("Waiting for models to load...")
        models_loaded.wait()
    
    if tokenizer is None or model is None or embedding_model is None:
        return jsonify({"error": "Models failed to load. Please try again later."}), 500
    
    data = request.get_json()
    user_question = data.get("message", "").lower().strip()

    thank_keywords = ["thank", "thanks", "thank you", "shukriya", "thnx", "appreciate"]
    if any(keyword in user_question for keyword in thank_keywords):
        return jsonify({"reply": "You're welcome! Let me know if you have more questions related to Autism.😊"})

    how_are_you_keywords = ["how are you", "how r u", "how's it going", "how are u"]
    if any(keyword in user_question.lower() for keyword in how_are_you_keywords):
        return jsonify({"reply": "I'm just an Educare bot, but I'm here to help you! 😊 How can I assist you today?"})

    input_embedding = embedding_model.encode(user_question, convert_to_tensor=True)
    scores = torch.nn.functional.cosine_similarity(input_embedding, question_embeddings)
    best_score = torch.max(scores).item()
    best_index = torch.argmax(scores).item()

    if best_score < 0.5:
        return jsonify({"reply": "Sorry, I cannot answer that question. You can ask me any question about Autism."})

    return jsonify({"reply": answers[best_index]})

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'png', 'jpg', 'jpeg', 'gif'}

def is_valid_name(name):
    return bool(re.match(r'^[A-Za-z ]+$', name))

def is_valid_password(password):
    return len(password) >= 6 and any(char.isdigit() for char in password)

@app.route('/api/add_child', methods=['POST'])
def add_child():
    try:
        data = request.get_json()
        name = data.get('name')
        password = data.get('password')
        age = data.get('age')
        image_base64 = data.get('image_base64')

        if not name or not password or age is None:
            return jsonify({'success': False, 'message': 'Name, password, and age are required.'}), 400

        if not is_valid_name(name):
            return jsonify({'success': False, 'message': 'Name must only contain alphabets and spaces.'}), 400

        if not isinstance(age, int) or age < 0 or age > 19:
            return jsonify({'success': False, 'message': 'Age must be between 0 and 19.'}), 400

        if not is_valid_password(password):
            return jsonify({'success': False, 'message': 'Password must be at least 6 characters and contain a digit.'}), 400

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM child_profiles WHERE name = %s AND password = %s", (name, password))
        if cur.fetchone():
            return jsonify({'success': False, 'message': 'Profile with this name and password already exists.'}), 400

        image_data = base64.b64decode(image_base64) if image_base64 else None
        cur.execute("""
            INSERT INTO child_profiles (name, password, age, image_blob)
            VALUES (%s, %s, %s, %s)
        """, (name, password, age, image_data))
        mysql.connection.commit()
        cur.close()

        return jsonify({'success': True, 'message': 'Child profile saved successfully.'}), 200

    except Exception as e:
        traceback.print_exc()
        return jsonify({'success': False, 'message': 'Server error: Unable to save profile.'}), 500

@app.route('/assess_autism', methods=['POST'])
def assess_autism():
    data = request.json
    scores = data.get("scores", [])

    if len(scores) != 15:
        return jsonify({"error": "Invalid input, 15 scores required"}), 400

    total_score = sum(scores)
    severity = "Severe Autism" if total_score >= 36 else "Moderate Autism" if 30 <= total_score < 36 else "No Autism or Mild Developmental Delay"
    deficient_areas = [CARS_CATEGORIES[i] for i, score in enumerate(scores) if score >= 3]

    return jsonify({
        "total_score": total_score,
        "severity": severity,
        # "deficient_areas": deficient_areas
    })

# Child login checkup
# This is the logic where child id is also retrieved

@app.route('/api/verify_child_login', methods=['POST'])
def verify_child_login():
    data = request.get_json()
    name = data.get('name')
    password = data.get('password')

    try:
        cursor = mysql.connection.cursor()
        # ✅ Fetch both id and password
        cursor.execute("SELECT id, password FROM child_profiles WHERE name = %s", (name,))
        result = cursor.fetchone()
        cursor.close()

        if result:
            child_id = result[0]               # ✅ Get id
            stored_password = result[1]

            # ✅ If password matches
            if stored_password == password:    # (Use check_password_hash if you hash later)
                return jsonify({
                    'success': True,
                    'id': child_id,            # ✅ Return child id for session saving
                    'name': name
                }), 200
            else:
                return jsonify({
                    'success': False,
                    'message': 'Incorrect password'
                }), 401
        else:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404

    except Exception as e:
        print("❌ Error verifying child login:", e)
        return jsonify({
            'success': False,
            'message': 'Server error'
        }), 500


@app.route('/child_list', methods=['GET'])
def get_child_data():
    try:
        cur = mysql.connection.cursor()
        # Modified: Use fetchall() instead of fetchone() to retrieve all child records
        cur.execute("SELECT name, password, image_blob FROM child_profiles")
        children = cur.fetchall()
        cur.close()

        if children:
            # Modified: Create a list of child profiles to return all records
            child_list = []
            for child in children:
                name, password, image_blob = child
                # Safely encode image_blob if it's not None
                image_blob_base64 = base64.b64encode(image_blob).decode('utf-8') if image_blob else None
                child_list.append({
                    'name': name,
                    'password': password,
                    'image_blob': image_blob_base64
                })
            # Modified: Return the list of children as JSON
            return jsonify(child_list), 200
        else:
            return jsonify({'error': 'No child profiles found'}), 404

    except Exception as e:
        print("Error in /child route:", e)  # Log the exact error
        return jsonify({'error': str(e)}), 500


# Added: New endpoint to fetch a specific child by name
@app.route('/child/<name>', methods=['GET'])
def get_child_by_name(name):
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT name, password, image_blob FROM child_profiles WHERE name = %s", (name,))
        child = cur.fetchone()
        cur.close()

        if child:
            name, password, image_blob = child
            image_blob_base64 = base64.b64encode(image_blob).decode('utf-8') if image_blob else None
            return jsonify({
                'name': name,
                'password': password,
                'image_blob': image_blob_base64
            }), 200
        else:
            return jsonify({'error': 'Child profile not found'}), 404

    except Exception as e:
        print("Error in /child/<name> route:", e)
        return jsonify({'error': str(e)}), 500

# Added: New endpoint to update a specific child by name
@app.route('/child/<name>', methods=['PUT'])
def update_specific_child(name):
    try:
        data = request.get_json()
        new_name = data.get('name')
        password = data.get('password')
        image_blob_base64 = data.get('image_blob')

        image_blob = base64.b64decode(image_blob_base64) if image_blob_base64 else None

        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE child_profiles SET name = %s, password = %s, image_blob = %s WHERE name = %s",
            (new_name, password, image_blob, name)
        )
        mysql.connection.commit()
        cur.close()

        return jsonify({'message': 'Profile updated successfully'}), 200

    except Exception as e:
        print("Error in /child/<name> route:", e)
        return jsonify({'error': str(e)}), 500

# Added: New endpoint to delete a child profile
@app.route('/child/<name>', methods=['DELETE'])
def delete_child(name):
    try:
        print(f"Deleting child with name: {name}")  # Debug: Log the deletion attempt
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM child_profiles WHERE TRIM(LOWER(name)) = TRIM(LOWER(%s))", (name,))
        if cur.rowcount > 0:
            mysql.connection.commit()
            cur.close()
            print(f"Child {name} deleted successfully")  # Debug: Log successful deletion
            return jsonify({'message': 'Child deleted successfully'}), 200
        else:
            cur.close()
            print(f"No child found to delete with name: {name}")  # Debug: Log when no child is found
            return jsonify({'error': 'Child profile not found'}), 404

    except Exception as e:
        print(f"Error in /child/{name} route: {e}")  # Debug: Log any errors
        return jsonify({'error': str(e)}), 500

# saira code

@app.route('/api/save-activity', methods=['POST'])
def save_activity():
    data = request.get_json()
    child_id = data['child_id']
    activity_name = data['activity_name']
    skill_category = data['skill_category']
    correct_phrases = data['correct_phrases']
    total_phrases = data['total_phrases']
    timestamp = datetime.datetime.now()

    try:
        cursor = mysql.connection.cursor()

        # Check if the record already exists
        cursor.execute("""
            SELECT * FROM child_activities 
            WHERE child_id = %s AND activity_name = %s
        """, (child_id, activity_name))
        existing = cursor.fetchone()

        if existing:
            # Update existing record
            cursor.execute("""
                UPDATE child_activities
                SET skill_category = %s,
                    correct_phrases = %s,
                    total_phrases = %s,
                    timestamp = %s
                WHERE child_id = %s AND activity_name = %s
            """, (skill_category, correct_phrases, total_phrases, timestamp, child_id, activity_name))
        else:
            # Insert new record
            cursor.execute("""
                INSERT INTO child_activities (child_id, activity_name, skill_category, correct_phrases, total_phrases, timestamp)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (child_id, activity_name, skill_category, correct_phrases, total_phrases, timestamp))

        mysql.connection.commit()
        cursor.close()
        return jsonify({'message': 'Activity saved/updated successfully'}), 200

    except Exception as e:
        print("❌ Error saving activity:", e)
        return jsonify({'message': 'Error saving activity'}), 500



# ✅ Get child activity progress
@app.route('/api/progress/<int:child_id>', methods=['GET'])
def get_progress(child_id):
    try:
        cursor = mysql.connection.cursor()
        cursor.execute("""
            SELECT activity_name, skill_category, correct_phrases, total_phrases, timestamp
            FROM child_activities
            WHERE child_id = %s
            ORDER BY timestamp DESC
        """, (child_id,))
        results = cursor.fetchall()
        cursor.close()

        progress = []
        for row in results:
            progress.append({
                'activity_name': row[0],
                'skill_category': row[1],
                'correct_phrases': row[2],
                'total_phrases': row[3],
                'timestamp': row[4].strftime('%Y-%m-%d %H:%M:%S')
            })

        return jsonify(progress), 200

    except Exception as e:
        print("❌ Error fetching progress:", e)
        return jsonify({'message': 'Error fetching progress'}), 500

@app.route('/submit_feedback', methods=['POST'])
def submit_feedback():
    data = request.get_json()
    message = data.get('message')

    if not message:
        return jsonify({'status': 'error', 'message': 'Message cannot be empty'}), 400

    try:
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO feedback (message) VALUES (%s)", (message,))
        mysql.connection.commit()
        cur.close()
        return jsonify({'status': 'success', 'message': 'Feedback submitted successfully'})
    except Exception as e:
        traceback.print_exc()
        return jsonify({'status': 'error', 'message': 'Database error'}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
