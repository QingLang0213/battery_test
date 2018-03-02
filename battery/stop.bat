@echo off
adb start-server
adb wait-for-device
adb shell touch  /sdcard/stop
echo.
echo.
echo OK, You Have Stopped It!
echo.
echo adb pull /sdcard/btm.csv  %cd%\%date:~0,4%%date:~5,2%%date:~8,2%btm.csv  
adb pull /sdcard/btm.csv  %cd%\%date:~0,4%%date:~5,2%%date:~8,2%btm.csv
echo.
echo You Can Press Enter key To Exit Window!
pause >nul