#adb shell "echo 256 > /sys/block/acte/queue/nr_requests"
#adb shell atrace -b 2000 --async_start input am sched disk 
#adb shell "busybox grep blkio  /proc/mounts || mkdir /sys/fs/cgroup/blkio; mount -t cgroup -o blkio none /sys/fs/cgroup/blkio"
#deliverInputEvent
#sh atrace.sh   old0 && atrace.sh   old1 && atrace.sh   old2&& atrace.sh   old3&& atrace.sh   old4&& atrace.sh   old5&& atrace.sh   old6&& atrace.sh   old7&& atrace.sh   old8&& atrace.sh   old9"
#sh atrace.sh   new0&&sh atrace.sh   new1&&sh atrace.sh   new2&&sh atrace.sh   new3&&sh atrace.sh   new4&&sh atrace.sh   new5&&sh atrace.sh   new6&&sh atrace.sh   new7&&sh atrace.sh   new8&&sh atrace.sh   new9
#adb shell  "busybox find /data/  -inum 298 "

# make android_initramfs android_system_img  android_pack_system_img  image firmware

#make kernel drivers && cd ../../../leopard/leopard/ && make && cd - && make android_system_img android_pack_system_img upramfs upramfs_image  image  firmware

# setenforce 0

if [ -z $1 ]
then
	out=atrace.txt
else
	out=$1
fi

flag=0x606e 


adb shell chmod 777 /sys
adb shell chmod 777 /sys/kernel
adb shell chmod 777 /sys/kernel/debug
adb shell chmod 777 /sys/kernel/debug/tracing


adb push pokeservice /data/
adb shell chmod 777 /data/pokeservice
adb shell sync

adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"
adb shell "echo 1  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "cat  /sys/kernel/debug/tracing/trace " > /dev/null

#setup ENV
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 80000  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo global  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"
#input wm  gfx am  input   view
#adb shell " setprop  debug.atrace.tags.enableflags  $flag"

printf "pokeservice \n"
#adb shell /data/pokeservice



#sched
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable" 


#adb shell  "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_wait/enable"  
#adb shell  "echo 1 > /sys/kernel/debug/tracing/events/sched/sched_stat_iowait/enable" 
# disk
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_exit/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_da_writepages/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_da_writepages_result/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_write_begin/enable" 

#adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_sleeprq/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_getrq/enable" 

# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_complete/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_bounce/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_remap/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_backmerge/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_frontmerge/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_plug/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_unplug/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_insert/enable" 

# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_dirty_buffer/enable" 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_touch_buffer/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_issue/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable" 
# sync
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/sync/enable"
#workqueue
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/workqueue/enable"
# writeback 
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_start/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_wait/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_written/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode_start/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable"
#vmscan
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/vmscan/enable"
#syscalls
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/syscalls/enable"
#jbd2
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/jbd2/enable"
# adb shell "echo 1 > /sys/kernel/debug/tracing/events/jbd2/jbd2_submit_inode_data/enable"

#adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/enable"


# jbd2_checkpoint
# jbd2_checkpoint_stats
# jbd2_commit_flushing
# jbd2_commit_locking
# jbd2_commit_logging
# jbd2_drop_transaction
# jbd2_end_commit
# jbd2_handle_extend
# jbd2_handle_start
# jbd2_handle_stats
# jbd2_lock_buffer_stall
# jbd2_run_stats
# jbd2_start_commit
# jbd2_submit_inode_data
# jbd2_update_log_tail
# jbd2_write_superblock

# fuction trace
#adb shell "echo function > /sys/kernel/debug/tracing/current_tracer"
#adb shell "echo  1  >/sys/kernel/debug/tracing/options/func_stack_trace"
#adb shell "echo elv_* ext4* DDL*  UTL* PDL* LDL*  VDL*  >/sys/kernel/debug/tracing/set_ftrace_filter"
#adb shell "echo account_page_dirtied   >/sys/kernel/debug/tracing/set_ftrace_filter"


# blk tracer

#adb  uninstall com.tencent.mobileqq


#start tracing
#adb shell "echo blk > /sys/kernel/debug/tracing/current_tracer"
#adb shell "echo 1 > /sys/block/acte/trace/enable"

adb shell " echo 0 > /sys/kernel/debug/tracing/events/vmscan/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/writeback/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/kmem/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/migrate/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/compaction/enable"
adb shell " echo 1 > /sys/kernel/debug/tracing/events/filemap/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/raw_syscalls/enable"
adb shell " echo 1 > /sys/kernel/debug/tracing/events/lowmem_killer/enable"


adb shell "echo 1 >  /sys/kernel/debug/tracing/tracing_on"
adb shell "cat  /sys/kernel/debug/tracing/trace_pipe"  > outdir/${out}

adb  logcat -c
#adb logcat -v time > outdir/${out}.logcat &


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
#adb shell "cat  /sys/kernel/debug/tracing/trace"  > outdir/${out}


#teardown ENV
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 1  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo local  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"
#input am sched disk 
adb shell " setprop  debug.atrace.tags.enableflags  0x0"
adb shell /data/pokeservice
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
#jbd2
adb shell "echo 0 > /sys/kernel/debug/tracing/events/jbd2/enable"
adb shell "echo 0 > /sys/kernel/debug/tracing/events/ext4/enable"
#workqueue
adb shell "echo 0 > /sys/kernel/debug/tracing/events/workqueue/enable"
# writeback 
adb shell "echo 0 > /sys/kernel/debug/tracing/events/writeback/enable"
#vmscan
adb shell "echo 0 > /sys/kernel/debug/tracing/events/vmscan/enable"
#syscalls
#adb shell "echo 0 > /sys/kernel/debug/tracing/events/syscalls/enable"
# fuction trace

#adb shell "echo  0  >/sys/kernel/debug/tracing/options/func_stack_trace"
#adb shell "echo  >/sys/kernel/debug/tracing/set_ftrace_filter"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"

printf "write result files"

python trace_html.py  outdir/${out} outdir/${out}.html
python trace_time.py  outdir/${out}.html  > outdir/${out}.time
#python trace_iowait.py  outdir/${out}.time  > outdir/${out}.iowait
#python trace_sync.py  outdir/${out}.time  > outdir/${out}.sync
#python trace_request.py  outdir/${out}.time  > outdir/${out}.req
python trace_strip.py  outdir/${out}.html  > outdir/${out}.strip.html
#python trace_nandreq.py  outdir/${out}.time  > outdir/${out}.nandreq
#python trace_issue.py  outdir/${out}.time  > outdir/${out}.issue


# block_getrq|block_rq_issue|block_rq_complete|ext4_readpage|mm_vmscan_lru_shrink_inactive|mm_vmscan_direct_reclaim_begin|mm_vmscan_kswapd_wake|mm_vmscan_wakeup_kswapd|mm_vmscan_lru_isolate|mm_migrate_pages|mm_filemap_add_to_page_cache|mm_filemap_delete_from_page_cache