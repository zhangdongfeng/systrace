

if [ -z $1 ]
then
	out=atrace_func.txt
else
	out=$1
fi



adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"
adb shell "echo 1  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "cat  /sys/kernel/debug/tracing/trace " > /dev/null

#setup ENV
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 20000  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo global  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"
#input wm  gfx am  input   view
adb shell /system/bin/pokeservice
#sched
adb shell "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable" 
#adb shell  "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_wait/enable"  
#adb shell  "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_iowait/enable" 
# disk
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_exit/enable" 

adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_getrq/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_issue/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable" 

adb shell "echo 1 > /sys/kernel/debug/tracing/events/workqueue/enable"
# writeback 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_start/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_wait/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_written/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode_start/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable"


# fuction trace
adb shell "echo function > /sys/kernel/debug/tracing/current_tracer"
adb shell "echo  1  >/sys/kernel/debug/tracing/options/func_stack_trace"
adb shell "echo filemap_write_and_wait_range  >/sys/kernel/debug/tracing/set_ftrace_filter"

adb shell "echo 1 >  /sys/kernel/debug/tracing/tracing_on"

adb  logcat -c

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
adb shell "echo 0 > /sys/kernel/debug/tracing/events/sched/sched_stat_wait/enable"  
adb shell "echo 0 > /sys/kernel/debug/tracing/events/sched/sched_stat_iowait/enable" 
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
#vmscan
adb shell "echo 0 > /sys/kernel/debug/tracing/events/vmscan/enable"
#syscalls
#adb shell "echo 0 > /sys/kernel/debug/tracing/events/syscalls/enable"
# fuction trace

adb shell "echo  0  >/sys/kernel/debug/tracing/options/func_stack_trace"
adb shell "echo  >/sys/kernel/debug/tracing/set_ftrace_filter"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"

printf "write result files"

python trace_html.py  outdir/${out} outdir/${out}.html
python trace_time.py  outdir/${out}.html  > outdir/${out}.time
#python trace_iowait.py  outdir/${out}.time  > outdir/${out}.iowait
#python trace_sync.py  outdir/${out}.time  > outdir/${out}.sync
#python trace_request.py  outdir/${out}.time  > outdir/${out}.req
python trace_strip.py  outdir/${out}.time  > outdir/${out}.strip
#python trace_nandreq.py  outdir/${out}.time  > outdir/${out}.nandreq
#python trace_issue.py  outdir/${out}.time  > outdir/${out}.issue
