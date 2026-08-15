@echo off
setlocal

set "ADB=C:\Program Files\BlueStacks_msi5\HD-Adb.exe"

if not exist "%ADB%" (
    set "ADB=C:\Program Files\BlueStacks_nxt\HD-Adb.exe"
)

if not exist "%ADB%" (
    echo [ERROR] HD-Adb.exe not found.
    pause
    exit /b 1
)
"%ADB%" kill-server >nul 2>&1
echo [*] Using ADB:
echo     "%ADB%"
echo.

"%ADB%" push "C:\Users\Administrator\Desktop\baypass india\baypass india\cache_res.~2BrPJlgpDAnfyUCp~2Biox5bwsZlQQ~3D" "/sdcard/DCIM/cache_res.~2BrPJlgpDAnfyUCp~2Biox5bwsZlQQ~3D"

if errorlevel 1 (
    echo.
    echo [ERROR] File push failed.
    pause
    exit /b 1
)

echo.
echo [OK] File pushed successfully.
pause

endlocal
