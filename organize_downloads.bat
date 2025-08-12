@echo off
REM File Organizer - Windows Batch Wrapper
REM This batch file runs the bash script for organizing downloads
REM Created for Windows Task Scheduler compatibility

REM Set the path to the bash script
set SCRIPT_PATH=D:\Marcelo\organize_downloads.sh

REM Try to run with Git Bash first (most common)
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" -c "'/d/Marcelo/organize_downloads.sh'"
    goto :end
)

REM Try alternative Git Bash location
if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    "C:\Program Files (x86)\Git\bin\bash.exe" -c "'/d/Marcelo/organize_downloads.sh'"
    goto :end
)

REM Try with WSL if available
where wsl >nul 2>nul
if %errorlevel% == 0 (
    wsl bash /d/Marcelo/organize_downloads.sh
    goto :end
)

REM Try with MSYS2 if available
if exist "C:\msys64\usr\bin\bash.exe" (
    "C:\msys64\usr\bin\bash.exe" -c "'/d/Marcelo/organize_downloads.sh'"
    goto :end
)

REM If no bash found, log error
echo [%date% %time%] ERROR: No bash interpreter found >> D:\Marcelo\organize_downloads.log
echo Please install Git for Windows or WSL >> D:\Marcelo\organize_downloads.log

:end
REM Exit quietly
exit /b 0
