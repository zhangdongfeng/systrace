sync 
echo 3 > /proc/sys/vm/drop_caches

#dd of=/dev/null if=/data/tmp1.bin bs=65536 count=5000&
#echo $!> /sys/fs/cgroup/blkio/fg/tasks && echo $!
sync 

echo "jdb group"
#dd if=/dev/zero of=/data/tmp.bin bs=65536 count=2000&
#echo $! > /sys/fs/cgroup/blkio/jbd/tasks && echo $!
dd of=/dev/null if=/data/tmp1.bin bs=65536 count=2000&
echo $! > /sys/fs/cgroup/blkio/jbd/tasks && echo $!


echo "fg group"

#dd if=/dev/zero of=/data/tmp2.bin bs=65536 count=2000&
#echo $! > /sys/fs/cgroup/blkio/fg/tasks && echo $!
dd of=/dev/null if=/data/tmp3.bin bs=65536 count=2000&
echo $! > /sys/fs/cgroup/blkio/fg/tasks && echo $!

echo "root group"

#dd if=/dev/zero of=/data/tmp4.bin bs=65536 count=2000&
#echo $! > /sys/fs/cgroup/blkio/tasks && echo $!
dd of=/dev/null if=/data/tmp5.bin bs=65536 count=2000&
echo $! > /sys/fs/cgroup/blkio/tasks && echo $!
sync 
echo 3 > /proc/sys/vm/drop_caches
sync 