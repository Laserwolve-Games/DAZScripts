Start-Process -FilePath "C:\Program Files\DAZ 3D\DAZStudio4\DAZStudio.exe" `
    -ArgumentList "-scriptArg", "1", ` # How many instances will be launched
                  "-instanceName", "#", ` # Incrementally number the instances
                  "-logSize", "500000000", ` # 500 MB
                  "-noPrompt", ` # https://github.com/Laserwolve-Games/DAZScripts/discussions/1
                  "C:\Users\Andre\OneDrive\repositories\DAZScripts\masterRenderer.dsa" # The script to execute on launch