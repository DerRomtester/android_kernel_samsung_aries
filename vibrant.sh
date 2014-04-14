#!/bin/bash
if [ "$CPU_JOB_NUM" = "" ] ; then
	CPU_JOB_NUM=`grep -c processor /proc/cpuinfo`
fi

echo "Making KK-4.4/CM-11.0 kernel for GS1 i9000"
BUILDVERSION=Neo-cm-11.0-`date +%Y%m%d`-mtwrp-cma
DATE_START=$(date +"%s")

make "vibrant_defconfig"

KERNEL_DIR=`pwd`
OUTPUT_DIR=../output
CWM_DIR=../ramdisk-aries/zip-stock/
MODULES_DIR=../ramdisk-aries/zip-stock/system/lib/modules/

echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "CWM_DIR="$CWM_DIR
echo "MODULES_DIR="$MODULES_DIR

make -j$CPU_JOB_NUM modules

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
chmod 644 `echo $MODULES_DIR"/*"`

make -j$CPU_JOB_NUM zImage

cp arch/arm/boot/zImage $CWM_DIR"boot.img"

echo "End of compiling kernel!"

echo "Create zip file..."
cd $CWM_DIR

zip -r `echo $BUILDVERSION`.zip *
mv  `echo $BUILDVERSION`.zip ../$OUTPUT_DIR"/"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
