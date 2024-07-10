@echo off
setlocal enabledelayedexpansion

rem List all .prg files in the c64-code\ directory
set index=1
for %%f in (c64-code\*.prg) do (
    echo !index!. %%~nf
    set "file[!index!]=%%~nf"
    set /a index+=1
)

rem Prompt user to choose a file
set /p choice="Enter the number corresponding to the file you want to launch in VICE: "

rem Validate user input
if not defined file[%choice%] (
    echo Invalid choice. Exiting script.
    exit /b 1
)

rem Launch VICE with the chosen file
set filename=!file[%choice%]!

start cmd /k "tools\vice64\bin\x64sc c64-code\!filename!.prg"
