@echo off
chcp 936 >nul
echo *******************************************************************************
echo.
echo.
echo		�����ü��ʱ�䡣��ÿ����û�ȡһ�ε�����Ϣ����λ�롣
echo.
echo		�������/sdcard/btm.csv �ļ��У�log����/sdcard/btm.log �ļ���
echo.		
echo		������;ֹͣ�ű�,��������stop.bat
echo		����ʹ������ adb shell touch /sdcard/stop
echo.
echo		���洢�ռ�����10%%��ֹͣ�ű������������豸ֹͣ�ű����С�
echo.
echo		�������ɵ�btm.csv�������˵�����£�		
echo		battery_status ��س��״̬	battery_health ��ؽ���״̬	
echo		battery_voltage ��ص�ѹ(V)	battery_capacity ʣ�������%��	
echo		temperature ����¶�(��)	cpufreq ��ǰcpu����Ƶ��
echo.		
echo.
echo *******************************************************************************
echo.
echo.
set /p sleep=�������ȡ����ʱ����(s)��

adb start-server
adb wait-for-device
adb push busybox /data/local/tmp
adb shell chmod 755 /data/local/tmp/busybox

adb push btm_stop.sh /data/local/tmp
echo {  sh /data/local/tmp/btm_stop.sh %sleep% ^& } ^>/sdcard/btm.log 2^>^&1 >temp.txt
echo run btm
adb start-server
adb wait-for-device
rem ��С��ִ��backcmd.bat
start /min backcmd.bat
adb shell <temp.txt
del temp.txt
echo.
echo OK, You Have Started It!
echo.
echo You Can Press Enter key To Exit Window!
pause >nul