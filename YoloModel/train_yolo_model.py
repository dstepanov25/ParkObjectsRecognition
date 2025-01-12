# Run in VS code:
#   open current folder in VS Code
#   run new Command Prompt Terminal
#   yolo_model_env\Scripts\activate
#   python train_yolo_model.py --data_dir "C:\ParkObjectsRecognition\YoloDataSet" --epochs 50 --yolo_model yolo11n.pt

import os
import argparse

from  ultralytics import YOLO
print(YOLO._version)

# Parse script arguments
parser = argparse.ArgumentParser(description="Train Model for offers.")
parser.add_argument("--data_dir", required=True, help="Path to the folder containing yolo train data for offers.")
parser.add_argument("--epochs", required=True, help="Number of epochs.")
parser.add_argument("--yolo_model", required=True, help="Basic model to train.")
args = parser.parse_args()

data_dir = args.data_dir
epochs = args.epochs
yolo_model = args.yolo_model

print(f"data_dir: {data_dir}, epochs: {epochs}, yolo_model: {yolo_model}")

# Test access to the folder with images
if os.path.isdir(data_dir):
    file_list = os.listdir(data_dir)
    print(file_list)
else:
    print(f"Error: Directory '{data_dir}' not found.")
    exit

# If you want to train from scratch, use 'yolo11n.pt', 'yolo11s.pt', etc., as a starting checkpoint.
model = YOLO(yolo_model)

# Train the model
results = model.train(
    data = f'{data_dir}/input/data.yaml',   # Path to your dataset YAML file
    epochs = int(epochs),                   # Number of epochs
    batch = 16,                             # Batch size
    imgsz = 640,                            # Image size for training
    name = 'park_exp',                      # Experiment name
    project = f'{data_dir}/train',          # Directory to save training results
)
