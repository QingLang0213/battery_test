@echo off
chcp 936 >nul
echo *******************************************************************************
echo.
echo.
echo		需设置间隔时间。即每隔多久获取一次电量信息，单位秒。
echo.
echo		结果存在/sdcard/btm.csv 文件中；log存在/sdcard/btm.log 文件中
echo.		
echo		如需中途停止脚本,可以运行stop.bat
echo		或者使用命令 adb shell touch /sdcard/stop
echo.
echo		当存储空间少于10%%则停止脚本；或者重启设备停止脚本运行。
echo.
echo		关于生成的btm.csv表格数据说明如下：		
echo		battery_status 电池充电状态	battery_health 电池健康状态	
echo		battery_voltage 电池电压(V)	battery_capacity 剩余电量（%）	
echo		temperature 电池温度(℃)	cpufreq 当前cpu工作频率
echo.		
echo.
echo *******************************************************************************
echo.
echo.
set /p sleep=请输入获取数据时间间隔(s)：

adb start-server
adb wait-for-device
adb push busybox /data/local/tmp
adb shell chmod 755 /data/local/tmp/busybox

adb push btm_stop.sh /data/local/tmp
echo {  sh /data/local/tmp/btm_stop.sh %sleep% ^& } ^>/sdcard/btm.log 2^>^&1 >temp.txt
echo run btm
adb start-server
adb wait-for-device
rem 最小化执行backcmd.bat
start /min backcmd.bat
adb shell <temp.txt
del temp.txt
echo.
echo OK, You Have Started It!
echo.
echo You Can Press Enter key To Exit Window!
pause >nul