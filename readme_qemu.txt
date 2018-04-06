1.1.2制作最小文件系统
下载busybox-1.28.2
$ export ARCH=arm
$ export CROSS_COMPILE=arm-linux-gnueabi-
并在menuconfig中配置静态编译CONFIG_STATIC=y； 然后执行make -j4; make install. 在busybox根目录下生成_install目录；该目录是编译好的文件系统需要的一些命令的集合。

将_install目录复制到kernel根目录下。然后cd _install并创建如下目录：
$ mkdir etc
$ mkdir dev
$ mkdir mnt
$ mkdir -p etc/init.d/
创建_install/etc/init.d/rcS文件，并写入：
mkdir -p /proc
mkdir -p /tmp
mkdir -p /sys
mkdir -p /mnt
/bin/mount -a
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
echo /sbin//mdev > /proc/sys/kernel/hotplug
并修改rcS的权限： chmod +x _install/etc/init.d/rcS

创建文件_install/etc/fstab，内容如下：
proc /proc proc defaults 0 0
tmpfs /tmp tmpfs defaults 0 0
sysfs /sys sysfs defaults 0 0
tmpfs /dev tmpfs defaults 0 0
Debugfs /sys/kernel/debug debugfs debugfs defaults 0 0

创建文件_install/etc/inittab，内容如下：
::sysinit:/etc/init.d/rcS
::respawn:~/bin/sh
::askfirst:~/bin/sh
::ctrlaltdel:/bin/umount -a -r

在_install/dev下创建如下设备节点：
$ cd _install/dev/
$ sudo mknod console c 5 1
$ sudo mknod null c 1 3

1.1.3启动内核
内核编译
$ cd linux-4.16
$ export ARCH=arm
$ export CROSS_COMPILE=arm-linux-gnueabi-
$ make vexpress_defconfig
配置initramfs source file： CONFIG_INITRAMFS_SOURCE="_install"

$ make bzImage -j4 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
$ make dtbs

运行QEMU来启动Linux Kernel（内嵌式ramfs)：
qemu-system-arm  -M vexpress-a9 -smp 4 -m 1024M -kernel zImage  -append "rdinit=/linuxrc console=ttyAMA0 loglevel=8" -dtb vexpress-v2p-ca9.dtb  -nographic


