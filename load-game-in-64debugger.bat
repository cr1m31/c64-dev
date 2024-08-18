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
set /p choice="Enter the number corresponding to the file you want to launch in C64Debugger: "

rem Validate user input
if not defined file[%choice%] (
    echo Invalid choice. Exiting script.
    exit /b 1
)

rem Assemble the chosen file using TMPx
set filename=!file[%choice%]!

rem Remove the .asm extension from the filename
set "filename_without_ext=!filename:.asm=!"

rem Check if filename contains spaces and quote if necessary
set "filename_without_ext=%filename_without_ext:"=""%"

echo !filename_without_ext!

start cmd /k "c64-tools\C64_Debugger_v0_64_58_6\C64Debugger c64-code\!filename_without_ext!.prg"
