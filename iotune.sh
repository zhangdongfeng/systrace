#cat slice_async  40
#cat slice_sync   100
#cat slice_async_rq 2
#cat slice_idle  10
#cat group_idle 10
#cat low_latency 1
#cat target_latency 300
#cat back_seek_max 16384
#cat back_seek_penalty 2
#cat quantum 8

#mount  cgroup filesystem
#adb shell "busybox grep blkio  /proc/mounts || mkdir /sys/fs/cgroup/blkio; mount -t cgroup -o blkio none /sys/fs/cgroup/blkio"


#adb shell "echo 93:16 2000 > /sys/fs/cgroup/blkio/blkio.throttle.read_iops_device"
#adb shell "echo 93:16 0 > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device"




# write throttle
#adb shell "echo 93:32 10242880 > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device"

# cpu cores
adb shell "echo 1  > /sys/devices/system/cpu/autoplug/usr_lock"
adb shell "echo 1  > /sys/devices/system/cpu/cpu0/online"
adb shell "echo 1  > /sys/devices/system/cpu/cpu1/online"
#adb shell "echo 1  > /sys/devices/system/cpu/cpu2/online"
#adb shell "echo 1  > /sys/devices/system/cpu/cpu3/online"

#mm
#adb shell "echo 40  > /proc/sys/vm/dirty_ratio"
#adb shell "echo 5  > /proc/sys/vm/dirty_background_ratio"
#adb  shell "echo 50 > /sys/block/acte/bdi/max_ratio"


#adb shell "echo 1 >   /sys/block/acte/queue/iosched/low_latency" 

#adb shell "echo 10 >   /sys/block/acte/queue/iosched/group_idle"
#adb shell "echo 200 >   /sys/block/acte/queue/iosched/slice_sync"
#adb shell "echo 16 >   /sys/block/acte/queue/iosched/quantum"
#adb shell "echo 1 > /sys/block/acte/queue/nomerges"

# data  
#adb shell "echo 1 > /sys/block/acte/queue/rq_affinity"
#adb shell "echo 1 > /sys/block/acte/queue/iosched/slice_async_rq"

adb shell "echo 10 >   /sys/block/acte/queue/iosched/slice_idle"
#adb shell "echo 0 > /sys/block/acte/queue/rotational"
#system

adb shell "echo 10 >   /sys/block/actc/queue/iosched/slice_idle"
#adb shell "echo 0 > /sys/block/actc/queue/rotational"

#misc

adb shell "echo 10 >   /sys/block/acta/queue/iosched/slice_idle"
#adb shell "echo 0 > /sys/block/acta/queue/rotational"

# adb shell "echo 1 > /sys/fs/cgroup/blkio/blkio.reset_stats"
#    for((i=1;i<100000;i++));do adb shell " cat /sys/fs/cgroup/blkio/blkio.io_wait_time"|grep  "93:16 Read";  sleep 3; done

#adb shell setenforce 0
#cgroup blkio
#    for pid in `adb shell cat  /sys/fs/cgroup/blkio/cgroup.procs`;do if [ -z `adb shell ionice $pid |grep  be ` ]; then  echo $pid; else echo `adb shell ionice $pid |grep  be `; adb shell ps $pid;fi;done  
#    for pid in `adb shell cat  /sys/fs/cgroup/blkio/fg/cgroup.procs`;do if [ -z `adb shell ionice $pid |grep  be ` ]; then  echo $pid; else echo `adb shell ionice $pid |grep  be `; adb shell ps $pid;fi;done 2>/dev/null
#for pid in `adb shell cat  /sys/fs/cgroup/blkio/cgroup.procs`;do adb shell ps $pid; done
#for pid in `adb shell cat  /sys/fs/cgroup/blkio/fg/cgroup.procs`;do adb shell ps $pid |grep -E "S|jbd" ; done
#for pid in `adb shell cat  /sys/fs/cgroup/blkio/jbd/tasks`;do adb shell ps $pid ; done

#

# echo $$; echo $$ > /sys/fs/cgroup/blkio/jbd/tasks && dd if=/dev/zero of=/data/tmp.bin bs=65536 count=5000 ; cat /sys/fs/cgroup/blkio/jbd/tasks  &
# echo $$; echo $$ > /sys/fs/cgroup/blkio/fg/tasks && dd if=/dev/zero of=/data/tmp1.bin bs=65536 count=5000 ; cat /sys/fs/cgroup/blkio/fg/tasks& 

# echo $$; echo $$ > /sys/fs/cgroup/blkio/jbd/tasks && dd of=/dev/null if=/data/tmp.bin bs=65536 count=5000  &
# echo $$; echo $$ > /sys/fs/cgroup/blkio/fg/tasks && dd of=/dev/null if=/data/tmp1.bin bs=65536 count=5000 & 

#adb shell mkdir -p /sys/fs/cgroup/blkio/jbd
#adb shell "echo 100 > /sys/fs/cgroup/blkio/jbd/blkio.weight"
#adb shell "echo 400 > /sys/fs/cgroup/blkio/blkio.leaf_weight"
#adb shell "echo 500 > /sys/fs/cgroup/blkio/fg/blkio.weight"
#adb shell "echo 100 > /sys/fs/cgroup/blkio/fg/blkio.leaf_weight"

#usage: ionice <pid> [none|rt|be|idle] [prio]
# ionice  zygote system_server, launcher, systemUI

adb shell "ps" > ps.txt
iopid=`python trace_ionice.py ps.txt 'zygote|system_server|com.android.systemui|com.android.launcher'`

for pid in $iopid 
do 
echo `adb shell ps $iopid`
#adb shell "ionice ${pid} be 0" 
#adb shell "echo ${pid} > /sys/fs/cgroup/blkio/fg/cgroup.procs"
done


# while true; do
# adb shell "ps -t" > ps.txt
# iopid=`python trace_ionice.py ps.txt 'dexopt|PackageManager|jbd2'`
# for pid in $iopid 
# do 
#db shell "ionice ${pid} be 0" 
# echo move $pid  to jbd group
# adb shell "echo ${pid} > /sys/fs/cgroup/blkio/jbd/tasks"
# done;
# sleep 2
# done


# iopid=`python trace_ionice.py ps.txt 'jbd'`
# echo $iopid
# for pid in $iopid 
# do 
# adb shell "ionice ${pid} none 0" 
# adb shell "echo ${pid} > /sys/fs/cgroup/blkio/jbd/cgroup.procs"
# done


