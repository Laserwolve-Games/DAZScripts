param (
    [string]$sourceDir = "C:\output",
    [string]$outputDir = "C:\PlainsOfShinar\spritesheets"
)

# Wait until no processes named "DazStudio" are running
while (Get-Process -Name "DazStudio" -ErrorAction SilentlyContinue) {
    Write-Output "Waiting for all instances of Daz Studio to close..."
    Start-Sleep -Seconds 5
}

$subDirs = Get-ChildItem -Path $sourceDir -Directory

foreach ($dir in $subDirs) {

    $folderName = $dir.Name
    $fullName = $dir.FullName

    Write-Output "Processing folder: $folderName"

    # Underscores instead of dashes in the file name weren't working
    TexturePacker "settings.tps" --sheet "$outputDir\$folderName\$folderName-{n}.webp" --data "$outputDir\$folderName\$folderName-{n}.json" $fullName

    if ((Test-Path "$outputDir\$folderName.webp") -and (Test-Path "$outputDir\$folderName.json")) {
        Remove-Item -Recurse -Force $fullName
    }
}