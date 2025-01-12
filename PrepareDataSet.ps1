param (
    [string]$SourceFolder,    # Source folder containing .jpg and .txt files
    [string]$OutputFolder     # Root folder for YOLO structure
)

function CountClasses {
    param (
        [array]$FilePath
    )

    # Читаємо кожен рядок файлу
    Get-Content -Path $FilePath | ForEach-Object {
        # Отримуємо ID класу (перший елемент у рядку)
        $classId = ($_ -split '\s+')[0]

        # Підраховуємо кількість об'єктів
        if ($classCounts.ContainsKey($classId)) {
            $classCounts[$classId]++
        } else {
            $classCounts[$classId] = 1
        }
    }
}

# Helper function to copy image and label files
function Copy-ImageAndLabel {
    param (
        [array]$Files,
        [string]$ImagesFolder,
        [string]$LabelsFolder
    )
    foreach ($jpgFile in $Files) {
        $baseName = $jpgFile.BaseName
        $txtFile = Join-Path $jpgFile.Directory "$baseName.txt"

        # Copy image file
        Copy-Item -Path $jpgFile.FullName -Destination $ImagesFolder

        # Copy label file if it exists
        if (Test-Path -Path $txtFile) {
            CountClasses -FilePath $txtFile
            Copy-Item -Path $txtFile -Destination $LabelsFolder
        }
    }
}

function GenerateDataFile {
    # Шлях для створення data.yaml
    $outputFile = "${OutputFolder}\data.yaml"

    # Генеруємо вміст data.yaml
    $dataYaml = @"
train: images/train
val:  images/val
test: images/test

nc: $($classes.Count)

names: ['$($classes -join "', '")']
"@

    # Зберігаємо data.yaml
    Set-Content -Path $outputFile -Value $dataYaml
}

$TrainSplit = 0.7    # Percentage of files for the train set
$ValSplit = 0.2      # Percentage of files for the validation set

$OutputFolder="${OutputFolder}\input"

# Define YOLO directories
$imagesTrain = Join-Path $OutputFolder "images\train"
$imagesVal = Join-Path $OutputFolder "images\val"
$imagesTest = Join-Path $OutputFolder "images\test"

$labelsTrain = Join-Path $OutputFolder "labels\train"
$labelsVal = Join-Path $OutputFolder "labels\val"
$labelsTest = Join-Path $OutputFolder "labels\test"

$classCounts = @{}
$classes = Get-Content -Path "${SourceFolder}\classes.txt"

# Create or clean directories
foreach ($folder in @($imagesTrain, $imagesVal, $imagesTest, $labelsTrain, $labelsVal, $labelsTest)) {
    if (-not (Test-Path -Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    } else {
        Remove-Item -Path "${folder}\*" -Force -Recurse
    }
}
Remove-Item -Path "$OutputFolder\labels\*.cache" -Force

GenerateDataFile

# Get all .jpg files
$jpgFiles = Get-ChildItem -Path $SourceFolder -Filter "*.jpg"

# Shuffle the files randomly
$jpgFiles = $jpgFiles | Get-Random -Count ([math]::Ceiling($jpgFiles.Count))

# Split into train and validation sets
$totalFiles = $jpgFiles.Count
$trainCount = [math]::Ceiling($totalFiles * $TrainSplit)
$trainFiles = $jpgFiles | Select-Object -First $trainCount
$valCount = [math]::Ceiling($totalFiles * $ValSplit)
$valFiles = $jpgFiles | Select-Object -Skip $trainCount -First $valCount
$testFiles = $jpgFiles | Select-Object -Skip ($trainCount + $valCount)

# Copy train files
Copy-ImageAndLabel -Files $trainFiles -ImagesFolder $imagesTrain -LabelsFolder $labelsTrain

# Copy validation files
Copy-ImageAndLabel -Files $valFiles -ImagesFolder $imagesVal -LabelsFolder $labelsVal

# Copy test files
Copy-ImageAndLabel -Files $testFiles -ImagesFolder $imagesTest -LabelsFolder $labelsTest

Write-Host "Organized files into YOLO structure:"
Write-Host "  Train images: $($trainFiles.Count)"
Write-Host "  Validation images: $($valFiles.Count)"
Write-Host "  Test images: $($testFiles.Count)"

Write-Host
Write-Host "Count of objects of each class:"
foreach ($classId in $classCounts.Keys) {
    Write-Host "  Class '$($classes[$classId])': $($classCounts[$classId]) objects"
}
