# from flask import Flask, request, jsonify
# from transformers import AutoTokenizer, AutoModelForQuestionAnswering
# from sentence_transformers import SentenceTransformer
# import pandas as pd
# import torch
# from flask_cors import CORS
# import base64
# import os
# import traceback
# import re  # For name validation
# from flask_mysqldb import MySQL
# from config import Config
# from werkzeug.utils import secure_filename

# app = Flask(__name__)
# app.config.from_object(Config)
# CORS(app)

# # MySQL Initialization
# mysql = MySQL(app)

# # ✅ Add this MySQL connection test INSIDE app.app_context()
# with app.app_context():
#     try:
#         cur = mysql.connection.cursor()
#         cur.execute("SELECT 1")
#         print("✅ Successfully connected to the MySQL database!")
#         cur.close()
#     except Exception as e:
#         print("❌ Failed to connect to the MySQL database:", e)
# # Load tokenizer and model
# tokenizer = AutoTokenizer.from_pretrained("tokenizer")
# model = AutoModelForQuestionAnswering.from_pretrained("model")
# embedding_model = SentenceTransformer("paraphrase-MiniLM-L6-v2")

# # Load your Q&A dataset
# df = pd.read_excel("autism_faqs.xlsx")
# questions = df["Question"].fillna("").tolist()
# answers = df["Answer"].fillna("").tolist()

# # Generate embeddings for all questions
# question_embeddings = embedding_model.encode(questions, convert_to_tensor=True)

# @app.route("/chat", methods=["POST"])
# def chat():
#     data = request.get_json()
#     user_question = data.get("message", "").lower().strip()

#     # Handle thank you messages (multiple variations)
#     thank_keywords = ["thank", "thanks", "thank you", "Shukriya", "thnx", "appreciate"]

#     if any(keyword in user_question for keyword in thank_keywords):
#         return jsonify({"reply": "You're welcome! Let me know if you have more questions related to Autism.😊"})
    
#     # Handle "how are you?" and similar greetings
#     how_are_you_keywords = ["how are you", "how r u", "how's it going", "how are u"]

#     if any(keyword in user_question.lower() for keyword in how_are_you_keywords):
#         return jsonify({"reply": "I'm just a Educare bot, but I'm here to help you! 😊 How can I assist you today?"})


#     # Generate embedding for input question
#     input_embedding = embedding_model.encode(user_question, convert_to_tensor=True)

#     # Compare with dataset
#     scores = torch.nn.functional.cosine_similarity(input_embedding, question_embeddings)
#     best_score = torch.max(scores).item()
#     best_index = torch.argmax(scores).item()

#     # Check similarity threshold
#     if best_score < 0.5:
#         return jsonify({
#             "reply": "Sorry, I cannot answer that question. You can ask me any question about Autism."
#         })

#     # Return best match
#     best_answer = answers[best_index]
#     return jsonify({"reply": best_answer})


# # Upload folder (optional - only used if saving files physically)
# UPLOAD_FOLDER = app.config['UPLOAD_FOLDER']
# ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

# if not os.path.exists(UPLOAD_FOLDER):
#     os.makedirs(UPLOAD_FOLDER)

# def allowed_file(filename):
#     """Check if the file has a valid extension."""
#     return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# def is_valid_name(name):
#     """Check if the name only contains alphabets and spaces."""
#     return bool(re.match(r'^[A-Za-z ]+$', name))

# def is_valid_password(password):
#     """Check if the password contains at least 6 characters and a digit."""
#     return len(password) >= 6 and any(char.isdigit() for char in password)

# @app.route('/api/add_child', methods=['POST'])
# def add_child():
#     try:
#         data = request.get_json()

#         name = data.get('name')
#         password = data.get('password')
#         age = data.get('age')
#         image_base64 = data.get('image_base64')

#         # Validation checks
#         if not name:
#             return jsonify({'success': False, 'message': 'Name is required.'}), 400
        
#         if not password:
#             return jsonify({'success': False, 'message': 'Password is required.'}), 400

#         if age is None:
#             return jsonify({'success': False, 'message': 'Age is required.'}), 400

#         # Check if the name contains only alphabets and spaces
#         if not is_valid_name(name):
#             return jsonify({'success': False, 'message': 'Name must only contain alphabets and spaces.'}), 400

#         # Check if the age is within the range 0-13
#         if not isinstance(age, int) or age < 0 or age > 13:
#             return jsonify({'success': False, 'message': 'Age must be between 0 and 13.'}), 400

#         # Check if password is strong
#         if len(password) < 6:
#             return jsonify({'success': False, 'message': 'Password must be at least 6 characters long.'}), 400
#         if not any(char.isdigit() for char in password):
#             return jsonify({'success': False, 'message': 'Password must contain at least one digit.'}), 400

#         # Check if the profile already exists
#         cur = mysql.connection.cursor()
#         cur.execute("SELECT * FROM child_profiles WHERE name = %s AND password = %s", (name, password))
#         existing_profile = cur.fetchone()

#         if existing_profile:
#             return jsonify({'success': False, 'message': 'Profile with this name and password already exists.'}), 400

#         # If all validations passed, handle the image upload
#         image_data = None
#         if image_base64:
#             try:
#                 image_data = base64.b64decode(image_base64)
#             except Exception:
#                 return jsonify({'success': False, 'message': 'Invalid image encoding.'}), 400

#         # Insert the new profile into the database
#         cur.execute("""
#             INSERT INTO child_profiles (name, password, age, image_blob)
#             VALUES (%s, %s, %s, %s)
#         """, (name, password, age, image_data))
#         mysql.connection.commit()
#         cur.close()

#         return jsonify({'success': True, 'message': 'Child profile saved successfully.'}), 200

#     except Exception as e:
#         traceback.print_exc()  # Print full error trace in console
#         return jsonify({'success': False, 'message': 'Server error: Unable to save profile.'}), 500

# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=8000, debug=True)



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
tokenizer = AutoTokenizer.from_pretrained("tokenizer")
model = AutoModelForQuestionAnswering.from_pretrained("model")
embedding_model = SentenceTransformer("paraphrase-MiniLM-L6-v2")

# Load Q&A dataset
df = pd.read_excel("autism_faqs.xlsx")
questions = df["Question"].fillna("").tolist()
answers = df["Answer"].fillna("").tolist()
question_embeddings = embedding_model.encode(questions, convert_to_tensor=True)

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

        if not isinstance(age, int) or age < 0 or age > 13:
            return jsonify({'success': False, 'message': 'Age must be between 0 and 13.'}), 400

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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
