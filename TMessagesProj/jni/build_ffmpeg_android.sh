#!/bin/bash

function build_one {

echo "Cleaning..."
rm config.h
make clean

echo "Configuring..."

./configure \
--cc=$CC \
--nm=$NM \
--enable-stripping \
--arch=$ARCH \
--target-os=linux \
--enable-cross-compile \
--x86asmexe=$NDK/prebuilt/$BUILD_PLATFORM/bin/yasm \
--prefix=$PREFIX \
--enable-pic \
--disable-shared \
--enable-static \
--enable-asm \
--enable-inline-asm \
--cross-prefix=$CROSS_PREFIX \
--sysroot=$PLATFORM \
--extra-cflags="-Wl,-Bsymbolic -Os -DCONFIG_LINUX_PERF=0 -DANDROID $OPTIMIZE_CFLAGS -fPIE -pie --static -fPIC" \
--extra-ldflags="-Wl,-Bsymbolic -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -fPIC" \
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
--disable-ffplay \
--disable-ffprobe \
--disable-postproc \
--disable-avdevice \
\
--enable-runtime-cpudetect \
--enable-pthreads \
--enable-avresample \
--enable-swscale \
--enable-protocol=file \
--enable-decoder=h264 \
--enable-decoder=mpeg4 \
--enable-decoder=mjpeg \
--enable-decoder=gif \
--enable-decoder=alac \
--enable-demuxer=mov \
--enable-demuxer=gif \
--enable-demuxer=ogg \
--enable-hwaccels \
--enable-runtime-cpudetect \
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

#x86_64
PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-21/arch-x86_64
LD=$PREBUILT/bin/x86_64-linux-android-ld
AR=$PREBUILT/bin/x86_64-linux-android-ar
NM=$PREBUILT/bin/x86_64-linux-android-nm
GCCLIB=$PREBUILT/lib/gcc/x86_64-linux-android/4.9.x/libgcc.a
CC=$PREBUILT/bin/x86_64-linux-android-gcc
CROSS_PREFIX=$PREBUILT/bin/x86_64-linux-android-
ARCH=x86_64
CPU=x86_64
PREFIX=./build/$CPU
ADDITIONAL_CONFIGURE_FLAG="--disable-mmx --disable-inline-asm"
#build_one

#arm64-v8a
PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-21/arch-arm64
LD=$PREBUILT/bin/aarch64-linux-android-ld
AR=$PREBUILT/bin/aarch64-linux-android-ar
NM=$PREBUILT/bin/aarch64-linux-android-nm
GCCLIB=$PREBUILT/lib/gcc/aarch64-linux-android/4.9.x/libgcc.a
CC=$PREBUILT/bin/aarch64-linux-android-gcc
CROSS_PREFIX=$PREBUILT/bin/aarch64-linux-android-
ARCH=arm64
CPU=arm64-v8a
OPTIMIZE_CFLAGS=
PREFIX=./build/$CPU
ADDITIONAL_CONFIGURE_FLAG="--enable-neon --enable-optimizations"
build_one


#arm v7n
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-16/arch-arm
LD=$PREBUILT/bin/arm-linux-androideabi-ld
AR=$PREBUILT/bin/arm-linux-androideabi-ar
NM=$PREBUILT/bin/arm-linux-androideabi-nm
GCCLIB=$PREBUILT/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
CC=$PREBUILT/bin/arm-linux-androideabi-gcc
CROSS_PREFIX=$PREBUILT/bin/arm-linux-androideabi-
ARCH=arm
CPU=armv7-a
OPTIMIZE_CFLAGS="-marm -march=$CPU"
PREFIX=./build/$CPU
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
build_one

#x86 platform
PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-16/arch-x86
LD=$PREBUILT/bin/i686-linux-android-ld
AR=$PREBUILT/bin/i686-linux-android-ar
NM=$PREBUILT/bin/i686-linux-android-nm
GCCLIB=$PREBUILT/lib/gcc/i686-linux-android/4.9.x/libgcc.a
CC=$PREBUILT/bin/i686-linux-android-gcc
CROSS_PREFIX=$PREBUILT/bin/i686-linux-android-
ARCH=x86
CPU=i686
OPTIMIZE_CFLAGS="-march=$CPU"
PREFIX=./build/$CPU
ADDITIONAL_CONFIGURE_FLAG="--disable-mmx --disable-yasm"
build_one
