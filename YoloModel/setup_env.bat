@echo off
REM Create a Python virtual environment
python -m venv yolo_model_env

REM Activate the virtual environment
call yolo_model_env\Scripts\activate.bat

REM Install the required packages
pip install ultralytics

REM Notify user of completion
echo.
echo Environment setup is complete.
echo.
pause
