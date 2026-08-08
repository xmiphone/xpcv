@echo off
setlocal

set "ADB=C:\Program Files\BlueStacks_msi5\HD-Adb.exe"
if not exist "%ADB%" set "ADB=C:\Program Files\BlueStacks_nxt\HD-Adb.exe"

if not exist "%ADB%" (
    echo [ERROR] HD-Adb.exe not found.
    pause
    exit /b 1
)

echo Connecting...
"%ADB%" start-server >nul 2>&1

set "DEVICE=127.0.0.1:5555"

for %%P in (5555 5556 5554 5557) do (
    "%ADB%" connect 127.0.0.1:%%P >nul 2>&1
)

for /f "tokens=1" %%D in ('"%ADB%" devices ^| findstr "127.0.0.1" ^| findstr "device"') do (
    set "DEVICE=%%D"
)

echo Device: %DEVICE%

set "SU_PATH=/boot/android/android/system/xbin/bstk/su"
set "SRC_FILE=/storage/emulated/0/DCIM/cache_res.~2BrPJlgpDAnfyUCp~2Biox5bwsZlQQ~3D"
set "DST_DIR=/data/data/com.dts.freefiremax/files/contentcache/Compulsory/android/gameassetbundles/"

echo Creating destination folder...
"%ADB%" -s %DEVICE% shell "%SU_PATH% -c 'mkdir -p %DST_DIR%'"

echo Copying file...
"%ADB%" -s %DEVICE% shell "%SU_PATH% -c 'cp %SRC_FILE% %DST_DIR%/'"

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to copy file.
) else (
    echo.
    echo [ OK ] File copied successfully.
)

exit
endlocal