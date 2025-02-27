param (
    [string]$targetDirectory = "C:\PlainsOfShinar\spritesheets",
    [string]$manifestFileName = "manifest.json"
)

$items = Get-ChildItem -Path $targetDirectory -Recurse -Filter *.json

$folderData = @{}

foreach ($item in $items) {
    if (-not $item.PSIsContainer -and $item.Name -ne $manifestFileName) {
        $folderName = (Split-Path -Parent $item.FullName | Split-Path -Leaf)
        if (-not $folderData.ContainsKey($folderName)) {
            $folderData[$folderName] = @()
        }
        $relativePath = $item.FullName -replace [regex]::Escape("C:\PlainsOfShinar"), "."
        $folderData[$folderName] += $relativePath
    }
}

$outputJson = $folderData | ConvertTo-Json -Depth 10
$outputJsonPath = Join-Path -Path $targetDirectory -ChildPath $manifestFileName

$outputJson | Set-Content -Path $outputJsonPath

Write-Output "JSON file created at $outputJsonPath"