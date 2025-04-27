import os

class Config:
    # MySQL Database Configurations
    MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.getenv('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', '')
    MYSQL_DB = os.getenv('MYSQL_DB', 'child_profiles_db')
    
    # Set the maximum content length for uploads (50 MB in this case)
    MAX_CONTENT_LENGTH = 50 * 1024 * 1024  # 50 MB limit
    
    # Upload folder location
    UPLOAD_FOLDER = 'uploads'
    
    # Flask Secret Key (Make sure to replace this with your own secret key in production)
    SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key')
