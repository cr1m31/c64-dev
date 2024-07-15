@echo off
setlocal enabledelayedexpansion

rem Initialize variables
set index=1

rem Read paths from list-of-asm-files.txt
for /f "tokens=*" %%a in (list-of-asm-files.txt) do (
    echo !index!. %%a
    set "file[!index!]=%%a"
    set /a index+=1
)

rem Prompt user to choose a file
set /p choice="Enter the number corresponding to the file you want to launch in VICE: "

rem Validate user input
if not defined file[%choice%] (
    echo Invalid choice. Exiting script.
    exit /b 1
)

rem Assemble the chosen file using TMPx
set filename=!file[%choice%]!

rem Check if filename contains spaces and quote if necessary
set "filename=%filename:"=""%"

echo !filename!

start cmd /k "c64-tools\vice64\bin\x64sc c64-code\!filename!.prg"
