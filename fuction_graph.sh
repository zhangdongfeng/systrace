
adb shell "echo 1 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 3000  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo global  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 1 >/sys/kernel/debug/tracing/options/print-tgid"


adb shell "echo function > /sys/kernel/debug/tracing/current_tracer"
 	
#adb shell "echo  1 > /sys/kernel/debug/tracing/options/funcgraph-abstime";	
#adb shell "echo  1  >/sys/kernel/debug/tracing/options/funcgraph-cpu";
#adb shell "echo  1  >/sys/kernel/debug/tracing/options/funcgraph-proc";	
#adb shell "echo  1  >/sys/kernel/debug/tracing/options/funcgraph-flat";
adb shell "echo  1  >/sys/kernel/debug/tracing/options/func_stack_trace"
#adb shell "echo  blk_start_plug >/sys/kernel/debug/tracing/set_ftrace_filter";
adb shell "echo  __blk_run_queue blk_finish_plug >/sys/kernel/debug/tracing/set_ftrace_filter"
adb shell "echo 1 >  /sys/kernel/debug/tracing/tracing_on "

printf "return:"
read input


adb shell "echo 0 >  /sys/kernel/debug/tracing/tracing_on "
adb shell "cat  /sys/kernel/debug/tracing/trace"  > fuction.txt

#adb shell "echo  0 > /sys/kernel/debug/tracing/options/funcgraph-abstime";	
#adb shell "echo  0  >/sys/kernel/debug/tracing/options/funcgraph-cpu";
#adb shell "echo  0  >/sys/kernel/debug/tracing/options/funcgraph-proc";	
#adb shell "echo  0  >/sys/kernel/debug/tracing/options/funcgraph-flat";
adb shell "echo 0 >/sys/kernel/debug/tracing/options/overwrite"
adb shell "echo 1  >/sys/kernel/debug/tracing/buffer_size_kb"
adb shell "echo local  >/sys/kernel/debug/tracing/trace_clock"
adb shell "echo 0 >/sys/kernel/debug/tracing/options/print-tgid"
adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"



