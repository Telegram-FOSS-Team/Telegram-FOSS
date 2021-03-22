#!/bin/bash
set -e
function build_one {
    CC="${CROSS_PREFIX}clang"
    CXX="${CROSS_PREFIX}clang++"
    AS="${CROSS_PREFIX}clang"
    AR="${CROSS_PREFIX}ar"
    LD="${CROSS_PREFIX}ld"
    NM="${CROSS_PREFIX}nm"
    STRIP="${CROSS_PREFIX}strip"

	echo "Cleaning..."
	rm -f config.h
	make clean || true
	rm -rf ${TOOLCHAIN_PREFIX}
	
	echo "Toolchain..."
	python $NDK/build/tools/make_standalone_toolchain.py \
	--arch ${ARCH} \
	--api ${ANDROID_API} \
	--stl libc++ \
	--install-dir=${TOOLCHAIN_PREFIX}

	echo "Configuring..."

	./configure \
	--nm=${NM} \
	--ar=${AR} \
	--as=${CROSS_PREFIX}gcc \
	--strip=${STRIP} \
	--cc=${CC} \
	--cxx=${CXX} \
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
    --enable-x86asm \
	--cross-prefix=$CROSS_PREFIX \
	--sysroot=$SYSROOT \
	--extra-cflags="-Wl,-Bsymbolic -Os -DCONFIG_LINUX_PERF=0 -DANDROID $OPTIMIZE_CFLAGS -fPIE -pie --static -fPIC" \
	--extra-ldflags="-Wl,-Bsymbolic -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -fPIC" \
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

BASEDIR=`pwd`
TOOLCHAIN_PREFIX=${BASEDIR}/toolchain-android

## common
SYSROOT=${TOOLCHAIN_PREFIX}/sysroot

#x86_64
ANDROID_API=21
PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-21/arch-x86_64
CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/x86_64-linux-android-
ARCH=x86_64
CPU=x86_64
PREFIX=./build/$CPU
ADDITIONAL_CONFIGURE_FLAG="--disable-asm"
build_one

#arm64-v8a
ANDROID_API=21
PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-21/arch-arm64
CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/aarch64-linux-android-
ARCH=arm64
CPU=arm64-v8a
OPTIMIZE_CFLAGS=
PREFIX=./build/$CPU
ADDITIONAL_CONFIGURE_FLAG="--enable-neon --enable-optimizations"
build_one


#arm v7n
ANDROID_API=16
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-16/arch-arm
CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/arm-linux-androideabi-
ARCH=arm
CPU=armv7-a
OPTIMIZE_CFLAGS="-marm -march=$CPU"
PREFIX=./build/armeabi-v7a
ADDITIONAL_CONFIGURE_FLAG="--enable-neon"
build_one

#x86 platform
ANDROID_API=16
PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/$BUILD_PLATFORM
PLATFORM=$NDK/platforms/android-16/arch-x86
CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/i686-linux-android-
ARCH=x86
CPU=i686
OPTIMIZE_CFLAGS="-march=$CPU"
PREFIX=./build/x86
ADDITIONAL_CONFIGURE_FLAG="--disable-x86asm --disable-inline-asm --disable-asm"
build_one
