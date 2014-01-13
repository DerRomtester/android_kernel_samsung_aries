#!/bin/bash
echo "Making KK-4.4/CM-11.0 kernel for GS1 i9000"
BUILDVERSION=x-aries-cm-11.0-`date +%Y%m%d`-mtwrp
DATE_START=$(date +"%s")

echo "Add recovery-ramdisk"
cp -vf source/mtwrp.img source/usr/galaxysmtd_initramfs_files/ramdisk-recovery.img

make "cyanogenmod_galaxysmtd_defconfig"

KERNEL_DIR=`pwd`
OUTPUT_DIR=../output
CWM_DIR=../ramdisk-aries/zip-stock/
MODULES_DIR=../ramdisk-aries/zip-stock/system/lib/modules/

echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "CWM_DIR="$CWM_DIR
echo "MODULES_DIR="$MODULES_DIR

make modules

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
chmod 644 `echo $MODULES_DIR"/*"`

make -j8 zImage

cp arch/arm/boot/zImage $CWM_DIR"boot.img"

echo "End of compiling kernel!"
echo "Delete recovery-ramdisk"
rm -vf source/usr/galaxysmtd_initramfs_files/ramdisk-recovery.img

echo "Create zip file..."
cd $CWM_DIR

zip -r `echo $BUILDVERSION`.zip *
mv  `echo $BUILDVERSION`.zip ../$OUTPUT_DIR"/"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
