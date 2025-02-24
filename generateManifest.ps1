param (
    [string]$targetDirectory # = "C:\PlainsOfShinar\spritesheets"
)

$items = Get-ChildItem -Path $targetDirectory -Recurse

$outputData = @() # Initialize as an array

foreach ($item in $items) {
    $outputData += [pscustomobject]@{
        Name = $item.Name
        FullName = $item.FullName
        ItemType = if ($item.PSIsContainer) { "Directory" } else { "File" }
    }
}

$outputJson = $outputData | ConvertTo-Json -Depth 10
$outputJsonPath = Join-Path -Path $targetDirectory -ChildPath "manifest.json"

$outputJson | Set-Content -Path $outputJsonPath

Write-Output "JSON file created at $outputJsonPath"