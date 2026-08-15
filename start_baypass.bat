@echo off
title Gang Xereca — Bypass 400
cd /d "%~dp0"
call "%~dp0baypassX.bat" com.dts.freefiremax
set "RC=%ERRORLEVEL%"
echo.
if %RC%==0 (
    echo [OK] Bypass done. Try login in Free Fire.
) else (
    echo [FAIL] See messages above.
)
pause
exit /b %RC%