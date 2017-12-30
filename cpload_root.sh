

#dd of=/dev/null if=/data/tmp1.bin bs=65536 count=5000&
#echo $!> /sys/fs/cgroup/blkio/fg/tasks && echo $!

#echo "93:32 4242880" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
echo "jdb group"
 dd if=/dev/zero of=/data/tmp.bin bs=65536 count=12000

 #echo $! > /sys/fs/cgroup/blkio/jbd/tasks && echo $!
# dd if=/dev/zero of=/data/tmp4.bin bs=65536 count=5000&
 #echo $! > /sys/fs/cgroup/blkio/jbd/tasks && echo $!
# dd if=/dev/zero of=/data/tmp2.bin bs=65536 count=5000&
# echo $! > /sys/fs/cgroup/blkio/jbd/tasks && echo $!

# dd of=/dev/null if=/data/tmp.bin bs=65536 count=5000&
# echo $! > /sys/fs/cgroup/blkio/fg/tasks && echo $!


# echo "fg group"


# dd of=/dev/null if=/data/tmp2.bin bs=65536 count=5000&
# echo $! > /sys/fs/cgroup/blkio/fg/tasks && echo $!

# echo "root group"


# dd of=/dev/null if=/data/tmp4.bin bs=65536 count=5000&
# echo $! > /sys/fs/cgroup/blkio/fg/tasks && echo $!

