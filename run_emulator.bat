@echo off
echo Starting Flutter app on emulator...
echo.

REM Navigate to project directory
cd /d "%~dp0"

REM Wait for emulator to be ready
echo Waiting for emulator to be ready...
timeout /t 5 /nobreak >nul

REM Check if emulator is ready
:check_emulator
C:\flutter\bin\flutter.bat devices | findstr "emulator" >nul
if %errorlevel% neq 0 (
    echo Emulator not ready yet, waiting 10 more seconds...
    timeout /t 10 /nobreak >nul
    goto check_emulator
)

echo.
echo Emulator is ready! Starting app...
echo.

REM Run the app
C:\flutter\bin\flutter.bat run

pause


