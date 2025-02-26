param (
    [string]$sourceDir = "C:\output",
    [string]$outputDir = "C:\PlainsOfShinar\spritesheets"
)

# Wait until no processes named "DazStudio" are running
while (Get-Process -Name "DazStudio" -ErrorAction SilentlyContinue) {
    Write-Output "Waiting for all instances of Daz Studio to close..."
    Start-Sleep -Seconds 5
}

TexturePacker --version

$subDirs = Get-ChildItem -Path $sourceDir -Directory

foreach ($dir in $subDirs) {

    $folderName = $dir.Name
    $fullName = $dir.FullName

    Write-Output "Processing folder: $folderName"

    TexturePacker "settings.tps" --sheet "$outputDir\$folderName\$folderName-{n}.webp" --data "$outputDir\$folderName\$folderName-{n}.json" $fullName

    # remove the source folder if files were successfully created
    if ((Test-Path "$outputDir\$folderName") -and ((Get-ChildItem "$outputDir\$folderName" | Measure-Object).Count -gt 0)) {
        Remove-Item -Recurse -Force $fullName
    }
}

# Create the manifest
$manifestScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "generateManifest.ps1"
& $manifestScriptPath -targetDirectory $outputDir