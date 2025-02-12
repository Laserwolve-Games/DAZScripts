param (
    [string]$sourceDir = "C:\output",
    [string]$outputDir = "C:\PlainsOfShinar\spritesheets"
)
$subDirs = Get-ChildItem -Path $sourceDir -Directory

foreach ($dir in $subDirs) {

    $folderName = $dir.Name
    $fullName = $dir.FullName

    Write-Output "Processing folder: $folderName"

    TexturePacker "settings.tps" --sheet "$outputDir\$folderName.webp" --data "$outputDir\$folderName.json" $fullName

    Remove-Item -Recurse -Force $fullName
}