#adb shell "echo 256 > /sys/block/acte/queue/nr_requests"
#adb shell atrace -b 2000 --async_start input am sched disk 
#adb shell "busybox grep blkio  /proc/mounts || mkdir /sys/fs/cgroup/blkio; mount -t cgroup -o blkio none /sys/fs/cgroup/blkio"
#deliverInputEvent
#sh atrace.sh   old0 && atrace.sh   old1 && atrace.sh   old2&& atrace.sh   old3&& atrace.sh   old4&& atrace.sh   old5&& atrace.sh   old6&& atrace.sh   old7&& atrace.sh   old8&& atrace.sh   old9"
#sh atrace.sh   new0&&sh atrace.sh   new1&&sh atrace.sh   new2&&sh atrace.sh   new3&&sh atrace.sh   new4&&sh atrace.sh   new5&&sh atrace.sh   new6&&sh atrace.sh   new7&&sh atrace.sh   new8&&sh atrace.sh   new9

# make android_initramfs android_system_img  android_pack_system_img  image firmware

#make kernel drivers && cd ../../../leopard/leopard/ && make && cd - && make android_system_img android_pack_system_img upramfs upramfs_image  image  firmware

# setenforce 0

if [ -z $1 ]
then
	out=blktrace.txt
else
	out=$1
fi

#define ATRACE_TAG_GRAPHICS         (1<<1)
#define ATRACE_TAG_INPUT            (1<<2)
#define ATRACE_TAG_VIEW             (1<<3)

#define ATRACE_TAG_WEBVIEW          (1<<4)
#define ATRACE_TAG_WINDOW_MANAGER   (1<<5)
#define ATRACE_TAG_ACTIVITY_MANAGER (1<<6)
#define ATRACE_TAG_SYNC_MANAGER     (1<<7)

#flag=0x6e  #input wm  gfx am  input   view
#flag=0x6e  # 0110 1110    am  wm    view  input gfx    
#flag=0x4e     # 0100 1110  am    view  input  gfx
#flag=0x0e     # 0100 1110  view  input   gfx
#flag=0x06     # 0100 0110   input  gfx  
#flag=0x04     # 0000 0100   input    
flag=0x46  #0100 0100   am input gfx


adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"
adb shell "cat  /sys/kernel/debug/tracing/trace " > /dev/null

#setup ENV
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 10000  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo global  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"


#adb shell " setprop  debug.atrace.tags.enableflags  $flag"
adb shell /system/bin/pokeservice

# disk
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_exit/enable" 


adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_issue/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable" 


adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_start/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_wait/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_written/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode_start/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable"

# blk tracer
adb shell "echo blk > /sys/kernel/debug/tracing/current_tracer"
adb shell "echo 1 > /sys/block/acte/trace/enable"
#adb  uninstall com.tencent.mobileqq


#start tracing

adb shell "echo 1 >  /sys/kernel/debug/tracing/tracing_on"
adb  logcat -c
#adb logcat -v time > outdir/${out}.logcat &

logcat=$!

#printf "insall qq.apk"

#adb  install -r  QQ.apk 

printf "stop tracing & specify output file [default atrace]"

if [ -z $1 ]
then
	read input
fi


if [ -z "$input"  ]
then
	printf "input is null"
else
	out=$input
fi


echo $out 


# stop  tracing
mkdir -p outdir

#adb shell kill $logcat
adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on "
adb shell "cat  /sys/kernel/debug/tracing/trace"  > outdir/${out}


#teardown ENV
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 1  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo local  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"
#input am sched disk 
adb shell " setprop  debug.atrace.tags.enableflags  0x0"
adb shell /system/bin/pokeservice
#sched
adb shell "echo 0 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable"
adb shell "echo 0 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable" 
#adb shell "echo 0 > /sys/kernel/debug/tracing/events/sched/sched_stat_wait/enable"  
#adb shell "echo 0 > /sys/kernel/debug/tracing/events/sched/sched_stat_iowait/enable" 
# disk
adb shell "echo 0 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable"
adb shell "echo 0 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_exit/enable"
 
adb shell "echo 0 > /sys/kernel/debug/tracing/events/block/enable"
adb shell "echo 0 > /sys/kernel/debug/tracing/events/block/block_rq_issue/enable" 
adb shell "echo 0 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable" 
# sync
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/sync/enable"
#workqueue
adb shell "echo 0 > /sys/kernel/debug/tracing/events/workqueue/enable"
# writeback 
adb shell "echo 0 > /sys/kernel/debug/tracing/events/writeback/enable"

# fuction trace

#adb shell "echo  0  >/sys/kernel/debug/tracing/options/func_stack_trace"
#adb shell "echo  >/sys/kernel/debug/tracing/set_ftrace_filter"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"
adb shell "echo 0 > /sys/block/acte/trace/enable"

printf "write result files"

#python trace_html.py  outdir/${out} outdir/${out}.html
#python trace_time.py  outdir/${out}.html  > outdir/${out}.time
#python trace_iowait.py  outdir/${out}.time  > outdir/${out}.iowait
#python trace_sync.py  outdir/${out}.time  > outdir/${out}.sync
#python trace_request.py  outdir/${out}.time  > outdir/${out}.req
#python trace_strip.py  outdir/${out}.time  > outdir/${out}.strip
#python trace_nandreq.py  outdir/${out}.time  > outdir/${out}.nandreq
