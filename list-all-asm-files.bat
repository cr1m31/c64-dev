@echo off
setlocal enabledelayedexpansion
set "baseDir=%CD%"
(
for /r "c64-code" %%i in (*.asm) do (
    set "filePath=%%i"
    set "relativePath=!filePath:%baseDir%\=!"
    echo !relativePath!
)
) > list-of-asm-files.txt

