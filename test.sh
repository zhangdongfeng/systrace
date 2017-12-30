#adb shell atrace -b 2000 --async_start input am sched disk 
#adb shell "busybox grep blkio  /proc/mounts || mkdir /sys/fs/cgroup/blkio; mount -t cgroup -o blkio none /sys/fs/cgroup/blkio"
#deliverInputEvent
if [ -z $1 ]
then
	o=test
else
	o=$1
fi

input=''
for((i=1;i<10;i++));do
sh _atrace_cgroup.sh   ${o}_$i 
echo ${o}_$i
python trace_iowait.py  outdir/${o}_$i.time  > outdir/${o}_$i.iowait
python trace_sync.py  outdir/${o}_$i.time  > outdir/${o}_$i.sync
input+=" outdir/${o}_$i.iowait outdir/${o}_$i.sync" 
done
echo $o
echo $input
python trace_sum.py $input  > outdir/${o}.sum


