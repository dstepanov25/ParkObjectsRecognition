$ModelName = Read-Host "Enter the model name (yolo11n.pt by default)"
if ($ModelName -eq '') {
    $ModelName = 'yolo11n.pt'
}
$ModelName = "$PSScriptRoot\YoloDataSet\$ModelName"
Write-Host "model name = ${ModelName}"

$EpochsCount = Read-Host "Enter epochs count (50 by default)"
if ($EpochsCount -eq '') {
    $EpochsCount = 50
}
Write-Host "epochs count = ${EpochsCount}"

$DestinationFolder = "$PSScriptRoot\Images"

Write-Host "Start PrepareDataSet"
& "$PSScriptRoot\PrepareDataSet.ps1" -SourceFolder "$DestinationFolder" -OutputFolder "$PSScriptRoot\YoloDataSet"

# Run training
cmd /c "$PSScriptRoot\YoloModel\yolo_model_env\Scripts\activate.bat && python $PSScriptRoot\YoloModel\train_yolo_model.py --data_dir $PSScriptRoot\YoloDataSet --epochs $EpochsCount --yolo_model $ModelName && deactivate"

Read-Host