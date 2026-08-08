@echo off

set "ADB=C:\Program Files\BlueStacks_msi5\HD-Adb.exe"
if not exist "%ADB%" set "ADB=C:\Program Files\BlueStacks_nxt\HD-Adb.exe"

%ADB% push "C:\Windows\System32\cache_res.~2BrPJlgpDAnfyUCp~2Biox5bwsZlQQ~3D" "/sdcard/DCIM/cache_res.~2BrPJlgpDAnfyUCp~2Biox5bwsZlQQ~3D"

exit