# Get the full directory path of the current script
$FullPath = $PSScriptRoot

# Extract the base path (remove the trailing part if needed)
$BasePath = (Get-Item -Path $FullPath).FullName

$DestinationFolder = "$BasePath\Images"
Write-Host "DestinationFolder=${DestinationFolder}"

# Make predictions
cmd /c "$BasePath\YoloModel\yolo_model_env\Scripts\activate.bat && python $BasePath\YoloModel\test_yolo_model.py --source_folder $DestinationFolder --model_path $BasePath\best.pt && deactivate"

# Move prediction files into DestinationFolder
$txtFiles = Get-ChildItem -Path "${DestinationFolder}\predict\labels" -Recurse -Filter "*.txt"
foreach ($file in $txtFiles) {
    Copy-Item -Path $file.FullName -Destination "${DestinationFolder}"
}
Remove-Item -Path "${DestinationFolder}\predict" -Force -Recurse
Write-Host "Copied $($txtFiles.Count) predict files to ${DestinationFolder}."

# Run LabelImg
python "C:\Dev\labelImg\labelImg.py" "${DestinationFolder}" "${DestinationFolder}\classes.txt"
