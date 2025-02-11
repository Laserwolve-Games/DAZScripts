$outputDir = "C:\output"

$subDirs = Get-ChildItem -Path $outputDir -Directory

foreach ($dir in $subDirs) {

    $folderName = $dir.Name

    TexturePacker --config "C:/assets/DAZScripts/settings.tps" --sheet "$outputDir\$folderName.webp" --data "$outputDir\$folderName.json" $dir.FullName

    Remove-Item -Recurse -Force $dir.FullName
}