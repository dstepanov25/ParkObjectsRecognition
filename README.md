# Інструкція для роботи з проектом

## 1. Підготовка зображень для тренування
1. Збережіть зображення для тренування у папці `/Images`.
2. Використовуючи програму для анотацій (наприклад, [LabelImg](https://github.com/heartexlabs/labelImg)), позначте об'єкти на зображеннях.
3. Збережіть анотації у форматі YOLO в тій самій папці `/Images`.

## 2. Підготовка датасету для навчання
1. Запустіть скрипт `PrepareDataSet.ps1`:
   ```powershell
   ./PrepareDataSet.ps1
   ```
2. Після виконання скрипту, дані для навчання моделі будуть готові.

## 3. Налаштування середовища для навчання
1. Запустіть файл `setup_env.bat`, який знаходиться у папці `ParkObjectsRecognition\YoloModel`:
   ```cmd
   ParkObjectsRecognition\YoloModel\setup_env.bat
   ```

## 4. Запуск процесу навчання моделі
1. Відкрийте PowerShell та активуйте віртуальне середовище для навчання:
   ```powershell
   yolo_model_env\Scripts\activate
   ```
2. Запустіть навчання моделі командою (відредактуйте шлях):
   ```powershell
   python train_yolo_model.py --data_dir "C:\ParkObjectsRecognition\YoloDataSet" --epochs 50 --yolo_model yolo11n.pt
   
