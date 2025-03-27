param (
    [string]$sourceDirectory,
    [string]$outputDirectory,
    [string]$manifestFileName = "manifest.json"
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
$items = Get-ChildItem -Path $outputDirectory -Recurse -Filter *.json

$folderData = @{}

foreach ($item in $items) {
    if (-not $item.PSIsContainer -and $item.Name -ne $manifestFileName) {
        $folderName = (Split-Path -Parent $item.FullName | Split-Path -Leaf)
        if (-not $folderData.ContainsKey($folderName)) {
            $folderData[$folderName] = @()
        }

        # Make the path relative to the spritesheets directory
        $relativePath = $item.FullName -replace [regex]::Escape($targetDirectory.substring(0,$targetDirectory.IndexOf('\spritesheets'))), "."
        # Replace the escaped backslashes with forward slashes
        $relativePath = $relativePath -replace "\\", "/"
        $folderData[$folderName] += $relativePath
    }
}

$outputJson = $folderData | ConvertTo-Json -Depth 10
$outputJsonPath = Join-Path -Path $outputDirectory -ChildPath $manifestFileName

$outputJson | Set-Content -Path $outputJsonPath

Write-Output "JSON file created at $outputJsonPath"