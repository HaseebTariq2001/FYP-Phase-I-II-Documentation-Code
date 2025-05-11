
###############################################################################################################################

from flask import Flask, request, jsonify
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

# Define CARS categories
CARS_CATEGORIES = [
    "Relationship with others", "Imitation skills", "Emotional responses", "Body usage",
    "Object usage", "Adaptation to change", "Visual response", "Auditory response",
    "Taste, smell, and tactile response", "Anxiety and fear", "Verbal communication",
    "Non-verbal communication", "Activity level", "Intellectual response", "General impressions"
]

@app.route("/chat", methods=["POST"])
def chat():
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

@app.route('/api/verify_child_login', methods=['POST'])
def verify_child_login():
    data = request.get_json()
    name = data.get('name')
    password = data.get('password')

    try:
        cursor = mysql.connection.cursor()
        # Replace with your actual table and column names
        cursor.execute("SELECT password FROM child_profiles WHERE name = %s", (name,))
        result = cursor.fetchone()
        cursor.close()

        if result:
            stored_password = result[0]
            if stored_password == password:  # Use check_password_hash if hashed
                return jsonify({'success': True}), 200
            else:
                return jsonify({'success': False, 'message': 'Incorrect password'}), 401
        else:
            return jsonify({'success': False, 'message': 'User not found'}), 404

    except Exception as e:
        print("❌ Error verifying child login:", e)
        return jsonify({'success': False, 'message': 'Server error'}), 500

# Fetch the first child profile
@app.route('/child', methods=['GET'])
def get_child():
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT name, password FROM child_profiles LIMIT 1")
        child = cur.fetchone()
        cur.close()
        if child:
            return jsonify({'name': child[0], 'password': child[1]}), 200
        else:
            return jsonify({'error': 'No child profile found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Update the first child profile
@app.route('/child', methods=['PUT'])
def update_child():
    try:
        data = request.get_json()
        name = data.get('name')
        password = data.get('password')

        cur = mysql.connection.cursor()
        cur.execute("UPDATE child_profiles SET name = %s, password = %s LIMIT 1", (name, password))
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Profile updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500





if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
