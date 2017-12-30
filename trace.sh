adb root
adb shell chmod 777 /sys
adb shell chmod 777 /sys/kernel
adb shell chmod 777 /sys/kernel/debug
adb shell chmod 777 /sys/kernel/debug/tracing

adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"
adb shell "echo 1  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "cat  /sys/kernel/debug/tracing/trace " > /dev/null

#setup ENV
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 1000  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo global  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"

adb shell " echo 0 > /sys/kernel/debug/tracing/events/block/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/kmem/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/vmscan/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/writeback/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/migrate/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/compaction/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/filemap/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/raw_syscalls/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/raw_syscalls/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/lowmem_killer/enable"

#adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_issue/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_sleeprq/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/block/block_getrq/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_exit/enable" 
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_readpage/enable"
adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_writepage/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_direct_IO_enter/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/kmem/mm_page_alloc/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/kmem/mm_page_free/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/kmem/mm_page_free_batched/enable"
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_congestion_wait/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_wait_iff_congested/enable" 
#adb shell "echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_writepage/enable" #pageout
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_shrink_slab_start/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_shrink_slab_end/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_direct_reclaim_begin/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_direct_reclaim_end/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_lru_shrink_inactive/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_kswapd_wake/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/mm_vmscan_wakeup_kswapd/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/migrate/mm_migrate_pages/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/filemap/mm_filemap_add_to_page_cache/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/filemap/mm_filemap_delete_from_page_cache/enable"

#adb shell "echo function > /sys/kernel/debug/tracing/current_tracer"
#adb shell "echo  1  >/sys/kernel/debug/tracing/options/func_stack_trace"
#adb shell "echo  block*  >/sys/kernel/debug/tracing/set_ftrace_filter"

#adb shell " echo 1 > /sys/kernel/debug/tracing/events/vmscan/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/writeback/enable"
adb shell " echo 1 > /sys/kernel/debug/tracing/events/migrate/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/compaction/enable"
adb shell " echo 1 > /sys/kernel/debug/tracing/events/filemap/enable"
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/raw_syscalls/enable"
adb shell " echo 1 > /sys/kernel/debug/tracing/events/lowmem_killer/enable"

#adb shell " echo 1 > /sys/kernel/debug/tracing/events/kmem/enable"


# block_getrq|block_rq_issue|block_rq_complete|ext4_readpage|mm_vmscan_lru_shrink_inactive|mm_vmscan_direct_reclaim_begin|mm_vmscan_kswapd_wake|mm_vmscan_wakeup_kswapd|mm_vmscan_lru_isolate|mm_migrate_pages|mm_filemap_add_to_page_cache|mm_filemap_delete_from_page_cache
#adb shell " echo 1 > /sys/kernel/debug/tracing/events/kmem/enable"

adb shell "echo 1 >  /sys/kernel/debug/tracing/tracing_on"

printf "stop tracing & specify output file [default atrace]"

if [ -z $1 ]
then
	read input
fi


if [ -z "$input"  ]
then
	printf "input is null"
	out=trace
else
	out=$input
fi



adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on "




adb shell "cat  /sys/kernel/debug/tracing/trace"  > outdir/${out}.txt

adb shell " echo 0 > /sys/kernel/debug/tracing/events/block/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/kmem/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/vmscan/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/writeback/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/migrate/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/compaction/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/filemap/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/raw_syscalls/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/raw_syscalls/enable"
adb shell " echo 0 > /sys/kernel/debug/tracing/events/lowmem_killer/enable"



adb shell "ls /sys/kernel/debug/tracing/events/"