@echo off
setlocal enabledelayedexpansion

rem Set the root directory for your code
set "rootDir=c64-code"
cd /d "%rootDir%"

rem Set path to TMPx assembler executable
set "TMPxPath=tools\TMPx\windows-i386\TMPx"

rem Initialize current path
set "currentPath=!CD!"

:main
rem List all folders and .asm files in the current directory
set index=1
echo Directories:
for /d %%d in (*) do (
    echo !index!. [DIR] %%~nxd
    set "dir[!index!]=%%d"
    set /a index+=1
)

echo Files:
for %%f in (*.asm) do (
    echo !index!. %%~nxf
    set "file[!index!]=%%f"
    set /a index+=1
)

rem Prompt user to choose a folder or a file
set /p choice="Enter the number corresponding to the folder or file you want to navigate/open: "

rem Validate user input for directory
if defined dir[%choice%] (
    set chosenDir=!dir[%choice%]!
    cd "!chosenDir!"
    set "currentPath=!CD!"
    goto main
)

rem Validate user input for file
if not defined file[%choice%] (
    echo Invalid choice. Exiting script.
    exit /b 1
)

rem Assemble the chosen file using TMPx
set filename=!file[%choice%]!

rem Construct full paths
set "asmFullPath=!currentPath!\!filename!"
set "prgFullPath=!asmFullPath:.asm=.prg!"

rem Assemble the chosen file using TMPx
if exist "!asmFullPath!" (
    start cmd /k "cd /d "!currentPath!" && "!TMPxPath!" -i "!asmFullPath!" -o "!prgFullPath!""
) else (
    echo File not found: !filename!
    exit /b 1
)

exit /b
