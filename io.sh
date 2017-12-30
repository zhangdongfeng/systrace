#adb shell "echo 0 > /sys/block/acte/queue/rotational"
#system

adb shell "echo 1  > /sys/devices/system/cpu/autoplug/usr_lock"
adb shell "echo 1  > /sys/devices/system/cpu/cpu0/online"
adb shell "echo 1  > /sys/devices/system/cpu/cpu1/online"
adb shell "echo 1  > /sys/devices/system/cpu/cpu2/online"
adb shell "echo 1  > /sys/devices/system/cpu/cpu3/online"

#adb shell "echo 40  > /proc/sys/vm/dirty_ratio"
#adb shell "echo 1048576  > /proc/sys/vm/dirty_background_bytes"
#adb shell "echo 262144  > /proc/sys/vm/dirty_background_bytes"

adb shell "echo 0 >   /sys/block/acte/queue/iosched/slice_idle"

adb shell "ps" > ps.txt
iopid=`python trace_ionice.py ps.txt 'zygote|system_server|com.android.systemui|com.android.launcher'`

for pid in $iopid 
do 
echo `adb shell ps $pid`
#adb shell "ionice ${pid} be 0" 
#adb shell "ionice ${pid} none 0" 
#adb shell "echo ${pid} > /sys/fs/cgroup/blkio/fg/cgroup.procs"
done