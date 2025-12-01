import os
import shutil

SOURCE_DIR = "/home/ubuntu/Downloads"

FILE_TYPES = {
    "Images": [".jpg", ".jpeg", ".png", ".gif"],
    "Documents": [".pdf", ".docx", ".txt", ".xlsx"],
    "Videos": [".mp4", ".mov", ".avi", ".mkv"],
    "Audio": [".mp3", ".wav"],
    "Archives": [".zip", ".tar", ".gz"],
    "Code": [".py", ".js", ".html", ".css"]
}

def create_folder(folder_path):
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

def sort_files():
    for file in os.listdir(SOURCE_DIR):
        file_path = os.path.join(SOURCE_DIR, file)

        if os.path.isdir(file_path):
            continue

        _, ext = os.path.splitext(file)
        ext = ext.lower()

        moved = False

        for category, extensions in FILE_TYPES.items():
            if ext in extensions:
                folder_path = os.path.join(SOURCE_DIR, category)
                create_folder(folder_path)
                shutil.move(file_path, os.path.join(folder_path, file))
                print(f"Moved: {file} -> {category}/")
                moved = True
                break

        if not moved:
            folder_path = os.path.join(SOURCE_DIR, "Others")
            create_folder(folder_path)
            shutil.move(file_path, os.path.join(folder_path, file))
            print(f"Moved: {file} -> Others/")

if __name__ == "__main__":
    print("Sorting files...")
    sort_files()
    print("Sorting complete.")

