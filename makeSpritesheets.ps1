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

    TexturePacker "settings.tps" --sheet "$outputDir\$folderName.webp" --data "$outputDir\$folderName.json" $fullName

    if ((Test-Path "$outputDir\$folderName.webp") -and (Test-Path "$outputDir\$folderName.json")) {
        Remove-Item -Recurse -Force $fullName
    }
}

# Execute the generateManifest.ps1 script
$manifestScriptPath = "C:\assets\DAZScripts\generateManifest.ps1"
if (Test-Path $manifestScriptPath) {
    Write-Output "Executing generateManifest.ps1..."
    & $manifestScriptPath
} else {
    Write-Output "generateManifest.ps1 not found at $manifestScriptPath"
}