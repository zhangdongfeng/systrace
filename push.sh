adb root
adb shell "mount -o remount,rw /system"
#adb  push U:/gs705a_new/android/out_atm7059tc_hr820ac/target/product/gs705a/system/framework/framework.jar /system/framework
#adb  push U:/gs705a_new/android/out_atm7059tc_hr820ac/target/product/gs705a/system/framework/core.jar /system/framework
#adb  push U:/gs705a_new/android/out_atm7059tc_hr820ac/target/product/gs705a/system/framework/services.jar /system/framework
adb  push U:/gs705a_0920/android/out_atm7059tc_hr820ac/target/product/gs705a/system/lib/libbinder.so  /system/lib
#adb  push U:/gs705a_new/android/out_atm7059tc_hr820ac/target/product/gs705a/system/bin/testfsync  /data/
#adb shell chmod 777 /data/testfsync
#adb shell "/data/testfsync /data/tmp1.bin"


adb push U:/gs705a_0920/android/out_atm7059tc_hr820ac/target/product/gs705a/system/bin/test_dlopen /data/
adb shell chmod 777 /data/test_dlopen
adb shell sync

adb  push  cpload_root.sh /data/
adb shell chmod 777 /data/cpload_root.sh
adb shell sync

adb shell stop
adb shell start

adb shell  "busybox find /data/  -inum 663 "