import base64
import os
import traceback
import re  # For name validation
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_mysqldb import MySQL
from config import Config
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)

# MySQL Initialization
mysql = MySQL(app)

# Upload folder (optional - only used if saving files physically)
UPLOAD_FOLDER = app.config['UPLOAD_FOLDER']
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

def allowed_file(filename):
    """Check if the file has a valid extension."""
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def is_valid_name(name):
    """Check if the name only contains alphabets and spaces."""
    return bool(re.match(r'^[A-Za-z ]+$', name))

def is_valid_password(password):
    """Check if the password contains at least 6 characters and a digit."""
    return len(password) >= 6 and any(char.isdigit() for char in password)

@app.route('/api/add_child', methods=['POST'])
def add_child():
    try:
        data = request.get_json()

        name = data.get('name')
        password = data.get('password')
        age = data.get('age')
        image_base64 = data.get('image_base64')

        # Validation checks
        if not name:
            return jsonify({'success': False, 'message': 'Name is required.'}), 400
        
        if not password:
            return jsonify({'success': False, 'message': 'Password is required.'}), 400

        if age is None:
            return jsonify({'success': False, 'message': 'Age is required.'}), 400

        # Check if the name contains only alphabets and spaces
        if not is_valid_name(name):
            return jsonify({'success': False, 'message': 'Name must only contain alphabets and spaces.'}), 400

        # Check if the age is within the range 0-13
        if not isinstance(age, int) or age < 0 or age > 13:
            return jsonify({'success': False, 'message': 'Age must be between 0 and 13.'}), 400

        # Check if password is strong
        if len(password) < 6:
            return jsonify({'success': False, 'message': 'Password must be at least 6 characters long.'}), 400
        if not any(char.isdigit() for char in password):
            return jsonify({'success': False, 'message': 'Password must contain at least one digit.'}), 400

        # Check if the profile already exists
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM child_profiles WHERE name = %s AND password = %s", (name, password))
        existing_profile = cur.fetchone()

        if existing_profile:
            return jsonify({'success': False, 'message': 'Profile with this name and password already exists.'}), 400

        # If all validations passed, handle the image upload
        image_data = None
        if image_base64:
            try:
                image_data = base64.b64decode(image_base64)
            except Exception:
                return jsonify({'success': False, 'message': 'Invalid image encoding.'}), 400

        # Insert the new profile into the database
        cur.execute("""
            INSERT INTO child_profiles (name, password, age, image_blob)
            VALUES (%s, %s, %s, %s)
        """, (name, password, age, image_data))
        mysql.connection.commit()
        cur.close()

        return jsonify({'success': True, 'message': 'Child profile saved successfully.'}), 200

    except Exception as e:
        traceback.print_exc()  # Print full error trace in console
        return jsonify({'success': False, 'message': 'Server error: Unable to save profile.'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
