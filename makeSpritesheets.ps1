param (
    [string]$sourceDirectory,
    [string]$outputDirectory
)

# Wait until no processes named "DazStudio" are running
while (Get-Process -Name "DazStudio" -ErrorAction SilentlyContinue) {
    Write-Output "Waiting for all instances of Daz Studio to close..."
    Start-Sleep -Seconds 5
}

TexturePacker --version

Write-Output "Source Directory: $sourceDirectory"
Write-Output "Output Directory: $outputDirectory"

$subDirs = Get-ChildItem -Path $sourceDirectory -Directory

foreach ($dir in $subDirs) {

    $folderName = $dir.Name
    $fullName = $dir.FullName

    Write-Output "Processing folder: $folderName"

    TexturePacker "settings.tps" --sheet "$outputDirectory\$folderName\$folderName-{n}.webp" --data "$outputDirectory\$folderName\$folderName-{n}.json" $fullName
}

# Create the manifest
$manifestScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "generateManifest.ps1"
& $manifestScriptPath -targetDirectory $outputDirectory