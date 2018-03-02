#!/system/bin/sh

# check file is exists
if [ -f /data/local/tmp/busybox ];then
	export bb="/data/local/tmp/busybox"
else
	echo "No /data/local/tmp/busybox"
	exit
fi
#delete btm.csv
if [ -f /sdcard/btm.csv ];then
	$bb rm /sdcard/btm.csv
fi

#delete stop
if [ -f /sdcard/stop ];then
	$bb rm /sdcard/stop
fi

echo "Date_Time,battery_status,battery_health,battery_voltage,battery_capacity,cpu_temperature,cpufreq" >/sdcard/btm.csv

# check file directory is exists
if [ -d /sys/class/power_supply/Battery ];then
	battery="/sys/class/power_supply/Battery"
elif [ -d /sys/class/power_supply/battery ];then
	battery="/sys/class/power_supply/battery"	
fi

if [ -f ${battery}"/temp" ];then
	temp=${battery}"/temp"
elif [ -f ${battery}"/batt_temp" ];then
	temp=${battery}"/batt_temp"
fi

while true;do
	tmp=`cat ${battery}"/capacity" $temp`
	if [ -f ${battery}"/voltage_now" ];then
		voltage=$((`cat ${battery}"/voltage_now"`/1000))
	elif [ -f ${battery}"/batt_vol" ];then
		voltage=`cat ${battery}"/batt_vol"`
	fi
	tmp2=`cat ${battery}"/status" ${battery}"/health"`
	part1=`echo $tmp2 $voltage $tmp|$bb awk '{a=$1;b=$2;c=sprintf("%.3f",$3/1000);d=$4;e=$5/10}END{printf a","b","c","d","e}'`
	part2=`cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq|$bb awk '{if(NR>1)printf "|";printf $1/1000}'`
	data_t=`date +%Y/%m/%d" "%H:%M:%S`
	
	echo $data_t","$part1","$part2>>/sdcard/btm.csv
	
	if [ -f /sdcard/stop ];then
		echo "Found stop file!!!"
		break
	elif [ `$bb df /data|$bb awk '{r=substr($(NF-1),1,length($(NF-1))-1)}END{print r+0}'` -ge 90 ];then
		echo "The free space of data less 10%,stop!!!"
		break
	fi
	sleep $1
done
