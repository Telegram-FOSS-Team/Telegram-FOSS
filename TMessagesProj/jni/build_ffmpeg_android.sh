#!/bin/bash

function build_one {

echo "Cleaning..."
make clean

echo "Configuring..."

./configure \
--cc=$CC \
--nm=$NM \
--enable-stripping \
--arch=$ARCH \
--cpu=$CPU \
--target-os=linux \
--enable-cross-compile \
--x86asmexe=$NDK/prebuilt/$BUILD_PLATFORM/bin/yasm \
--prefix=$PREFIX \
--enable-pic \
--disable-shared \
--enable-static \
--cross-prefix=$CROSS_PREFIX \
--sysroot=$PLATFORM \
--extra-cflags="-Os -DANDROID $OPTIMIZE_CFLAGS -fPIE -pie --static" \
--extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl" \
--extra-libs="-lgcc" \
\
--enable-version3 \
--enable-gpl \
\
--disable-linux-perf \
\
--disable-doc \
--disable-htmlpages \
--disable-avx \
\
--disable-everything \
--disable-network \
--disable-zlib \
--disable-avfilter \
--disable-avdevice \
--disable-postproc \
--disable-debug \
--disable-programs \
--disable-network \
--disable-ffserver \
--disable-ffplay \
--disable-ffprobe \
--disable-swscale \
--disable-postproc \
--disable-avdevice \
\
--enable-pthreads \
--enable-protocol=file \
--enable-decoder=h264 \
--enable-decoder=gif \
--enable-demuxer=mov \
--enable-demuxer=gif \
--enable-hwaccels \
--enable-runtime-cpudetect \
--enable-asm \
$ADDITIONAL_CONFIGURE_FLAG

#echo "continue?"
#read
make -j$COMPILATION_PROC_COUNT
make install

}

function setCurrentPlatform {

    PLATFORM="$(uname -s)"
    case "${PLATFORM}" in
        Darwin*)
                    BUILD_PLATFORM=darwin-x86_64
                    COMPILATION_PROC_COUNT=`sysctl -n hw.physicalcpu`
                    ;;
        Linux*)
                    BUILD_PLATFORM=linux-x86_64
                    COMPILATION_PROC_COUNT=$(nproc)
                    ;;
        *)
                    echo -e "\033[33mWarning! Unknown platform ${PLATFORM}! falling back to linux-x86_64\033[0m"
                    BUILD_PLATFORM=linux-x86_64
                    COMPILATION_PROC_COUNT=1
                    ;;
    esac

    echo "build platform: ${BUILD_PLATFORM}"
    echo "parallel jobs: ${COMPILATION_PROC_COUNT}"

}

function checkPreRequisites {

    if ! [ -d "ffmpeg" ] || ! [ "$(ls -A ffmpeg)" ]; then
        echo -e "\033[31mFailed! Submodule 'ffmpeg' not found!\033[0m"
        echo -e "\033[31mTry to run: 'git submodule init && git submodule update'\033[0m"
        exit
    fi

    if [ -z "$NDK" -a "$NDK" == "" ]; then
        echo -e "\033[31mFailed! NDK is empty. Run 'export NDK=[PATH_TO_NDK]'\033[0m"
        exit
    fi
}

setCurrentPlatform
checkPreRequisites

# TODO: fix env variable for NDK
# NDK=/opt/android-sdk/ndk-bundle

cd ffmpeg

#arm platform
PLATFORM=$NDK/platforms/android-16/arch-arm
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/$BUILD_PLATFORM
LD=$PREBUILT/bin/arm-linux-androideabi-ld
AR=$PREBUILT/bin/arm-linux-androideabi-ar
NM=$PREBUILT/bin/arm-linux-androideabi-nm
GCCLIB=$PREBUILT/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
ARCH=arm
CC=$PREBUILT/bin/arm-linux-androideabi-gcc
CROSS_PREFIX=$PREBUILT/bin/arm-linux-androideabi-

#arm v5
CPU=armv5te
OPTIMIZE_CFLAGS="-marm -march=$CPU"
PREFIX=./android/$CPU
ADDITIONAL_CONFIGURE_FLAG="--disable-armv6 --disable-armv6t2 --disable-vfp --disable-neon"
build_one

#arm v7n
CPU=armv7-a
OPTIMIZE_CFLAGS="-marm -march=$CPU"
PREFIX=./android/$CPU
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
build_one

#x86 platform
PLATFORM=$NDK/platforms/android-16/arch-x86
PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/$BUILD_PLATFORM
LD=$PREBUILT/bin/i686-linux-android-ld
AR=$PREBUILT/bin/i686-linux-android-ar
NM=$PREBUILT/bin/i686-linux-android-nm
GCCLIB=$PREBUILT/lib/gcc/i686-linux-android/4.9.x/libgcc.a
ARCH=x86
CC=$PREBUILT/bin/i686-linux-android-gcc
CROSS_PREFIX=$PREBUILT/bin/i686-linux-android-

CPU=i686
OPTIMIZE_CFLAGS="-march=$CPU"
PREFIX=./android/$CPU
ADDITIONAL_CONFIGURE_FLAG="--disable-mmx --disable-yasm"
build_one


