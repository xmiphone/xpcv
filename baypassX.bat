@echo off
setlocal enabledelayedexpansion

::  
:: Usage: rin.bat [packageName]

set "PACKAGE_NAME=%~1"
if "%PACKAGE_NAME%"=="" set "PACKAGE_NAME=com.dts.freefiremax"

set "HERE=%~dp0"
set "DEVICE=127.0.0.1:5555"
set "SU_PATH=/boot/android/android/system/xbin/bstk/su"
set "SD_CACHE=/data/local/tmp"
set "DATA_LOCAL=/data/local"
set "INJECTOR=baypassBlood"
set "LIB=Bloodlibs.so"
set "INJECTOR_LOCAL=%HERE%%INJECTOR%"
set "LIB_LOCAL=%HERE%%LIB%"

if not exist "%INJECTOR_LOCAL%" (
    echo [ERROR] Missing: %INJECTOR_LOCAL%
    exit /b 1
)
if not exist "%LIB_LOCAL%" (
    echo [ERROR] Missing: %LIB_LOCAL%
    exit /b 1
)

echo ============================================================
echo  BloodX — Bypass 400
echo  Target: %PACKAGE_NAME%
echo ============================================================

set "ADB=C:\Program Files\BlueStacks_msi5\HD-Adb.exe"
if not exist "%ADB%" set "ADB=C:\Program Files\BlueStacks\HD-Adb.exe"
if not exist "%ADB%" (
    echo [ERROR] HD-Adb.exe not found
    exit /b 1
)

echo [1/7] Connecting...
"%ADB%" start-server >nul 2>&1
for %%P in (5555 5556 5554 5557) do "%ADB%" connect 127.0.0.1:%%P >nul 2>&1
for /f "tokens=1" %%D in ('"%ADB%" devices ^| findstr "127.0.0.1" ^| findstr "device"') do set "DEVICE=%%D"
echo Device: %DEVICE%
timeout /t 1 /nobreak >nul

echo [*] Forwarding port 21405...
"%ADB%" -s %DEVICE% forward tcp:21405 tcp:21405 >nul 2>&1

echo [2/7] Cleaning...
"%ADB%" -s %DEVICE% logcat -c >nul 2>&1
"%ADB%" -s %DEVICE% shell "%SU_PATH% -c 'rm -f %DATA_LOCAL%/%INJECTOR% %DATA_LOCAL%/%LIB% %DATA_LOCAL%/injectionlib %DATA_LOCAL%/libindia.so'"
"%ADB%" -s %DEVICE% shell "rm -f %SD_CACHE%/%INJECTOR% %SD_CACHE%/%LIB%"
timeout /t 1 /nobreak >nul

echo [3/7] Staging...
"%ADB%" -s %DEVICE% shell "mkdir -p %SD_CACHE%"
timeout /t 1 /nobreak >nul

echo [4/7] Pushing...
"%ADB%" -s %DEVICE% push "%INJECTOR_LOCAL%" %SD_CACHE%/%INJECTOR%
if errorlevel 1 ( echo [ERROR] push injector failed & exit /b 1 )
"%ADB%" -s %DEVICE% push "%LIB_LOCAL%" %SD_CACHE%/%LIB%
if errorlevel 1 ( echo [ERROR] push lib failed & exit /b 1 )
timeout /t 1 /nobreak >nul

echo [5/7] Moving to %DATA_LOCAL%...
"%ADB%" -s %DEVICE% shell "%SU_PATH% -c 'cp %SD_CACHE%/%INJECTOR% %DATA_LOCAL%/%INJECTOR% && cp %SD_CACHE%/%LIB% %DATA_LOCAL%/%LIB%'"
if errorlevel 1 ( echo [ERROR] mv failed & exit /b 1 )
timeout /t 1 /nobreak >nul

echo [6/7] Injecting...
"%ADB%" -s %DEVICE% shell "%SU_PATH% -c 'chmod 777 %DATA_LOCAL%/%INJECTOR% %DATA_LOCAL%/%LIB% && %DATA_LOCAL%/%INJECTOR% -pkg %PACKAGE_NAME% -lib %DATA_LOCAL%/%LIB% -no-entry -v'"
if errorlevel 1 ( echo [ERROR] injection failed & exit /b 1 )
echo [ OK ] Injection succeeded.
timeout /t 2 /nobreak >nul

echo [7/7] Cleanup...
"%ADB%" -s %DEVICE% shell "%SU_PATH% -c 'rm -f %DATA_LOCAL%/%INJECTOR% %DATA_LOCAL%/%LIB%'"
"%ADB%" -s %DEVICE% shell "rm -f %SD_CACHE%/%INJECTOR% %SD_CACHE%/%LIB%"

echo.
echo Done. Open Free Fire login screen.
echo ============================================================
endlocal
exit
