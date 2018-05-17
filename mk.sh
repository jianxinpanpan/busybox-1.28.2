make defconfig
make CROSS_COMPILE=arm-linux-gnueabi-
make install CROSS_COMPILE=arm-linux-gnueabi- CONFIG_PREFIX=`pwd`/../tiny_tools/busybox-1.28_bin/
