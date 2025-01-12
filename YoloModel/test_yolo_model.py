# Run in VS code:
#   open current folder in VS Code
#   run new Command Prompt Terminal
#   yolo_model_env\Scripts\activate
#   python test_yolo_model.py --source_folder "C:\ParkObjectsRecognition\Images" --model_path "C:\ParkObjectsRecognition\best.pt"

import argparse
from pathlib import Path
from ultralytics import YOLO

# Parse script arguments
parser = argparse.ArgumentParser(description="Save Cropped Images.")
parser.add_argument("--source_folder", required=True, help="Path to the folder containing images.")
parser.add_argument("--model_path", required=True, help="Path to the YOLO model file (e.g., best.pt).")
args = parser.parse_args()

source_folder = args.source_folder
model_path = args.model_path

print(f"source_folder: {source_folder}, model_path: {model_path}")

# Load the YOLO model
model = YOLO(model_path)

# Ensure the source folder exists
source_folder = Path(source_folder)
if not source_folder.is_dir():
    print(f"Error: Source folder '{source_folder}' does not exist.")
    exit()

results = model.predict(source_folder, conf=0.9, save=False, save_txt=True, project=source_folder, name="")
