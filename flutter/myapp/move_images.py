
import os
import re
import shutil

# Set this to your Flutter project root directory
PROJECT_ROOT = './'  # Change if needed
ASSETS_DIR = os.path.join(PROJECT_ROOT, 'assets')
IMAGES_DIR = os.path.join(ASSETS_DIR, 'images')

# Supported image extensions
IMAGE_EXTENSIONS = ('.png', '.jpg', '.jpeg','.webp','.svg')

def move_images_to_images_folder():
    if not os.path.exists(IMAGES_DIR):
        os.makedirs(IMAGES_DIR)
    
    # Move all images from assets/ to assets/images/
    for item in os.listdir(ASSETS_DIR):
        item_path = os.path.join(ASSETS_DIR, item)
        if os.path.isfile(item_path) and item.lower().endswith(IMAGE_EXTENSIONS):
            dest_path = os.path.join(IMAGES_DIR, item)
            print(f"Moving: {item_path} → {dest_path}")
            shutil.move(item_path, dest_path)

def update_image_paths_in_dart_files():
    for subdir, _, files in os.walk(PROJECT_ROOT):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(subdir, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                original_content = content

                # Regex: Find assets/image.png (but NOT assets/images/image.png)
                content = re.sub(
                    r"assets/(?!(images/))([a-zA-Z0-9_\-]+\.(png|jpg|jpeg|svg|webp))",
                    r"assets/images/\2",
                    content
                )

                if content != original_content:
                    shutil.copy2(file_path, file_path + '.bak')
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Updated: {file_path}")

    print("✅ Dart files updated successfully.")

if __name__ == '__main__':
    move_images_to_images_folder()
    update_image_paths_in_dart_files()
