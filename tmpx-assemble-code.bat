@echo off
setlocal enabledelayedexpansion

rem List all .asm files in the c64-code\ directory
set index=1
for %%f in (c64-code\*.asm) do (
    echo !index!. %%~nf
    set "file[!index!]=%%~nf"
    set /a index+=1
)

rem Prompt user to choose a file
set /p choice="Enter the number corresponding to the file you want to assemble: "

rem Validate user input
if not defined file[%choice%] (
    echo Invalid choice. Exiting script.
    exit /b 1
)

rem Assemble the chosen file using TMPx
set filename=!file[%choice%]!

start cmd /k "c64-tools\TMPx\windows-i386\TMPx -i c64-code\!filename!.asm -o c64-code\!filename!.prg"