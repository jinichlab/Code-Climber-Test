@echo off
REM Click-to-launch for Windows. Double-click this file to start Code Climber.

cd /d "%~dp0"

set PORT=8765
set PAGE=codeclimber_rdkit.html
set URL=http://localhost:%PORT%/%PAGE%

REM Find Python 3
where python >nul 2>nul
if %errorlevel%==0 (
  set PY=python
) else (
  where py >nul 2>nul
  if %errorlevel%==0 (
    set PY=py -3
  ) else (
    echo Python 3 not found. Install from https://www.python.org/downloads/
    echo Make sure to tick "Add Python to PATH" during install.
    pause
    exit /b 1
  )
)

REM Open the browser after a brief delay
start "" cmd /c "timeout /t 2 >nul & start """ %URL%"

echo ================================================================
echo   Code Climber is running at: %URL%
echo   Close this window to stop the server.
echo ================================================================
echo.

%PY% -m http.server %PORT%
