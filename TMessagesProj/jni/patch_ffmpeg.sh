#!/bin/bash

set -e

patch -d ffmpeg -p1 < patches/ffmpeg/0001-compilation-magic.patch

cp ffmpeg/libavformat/dv.h ffmpeg/build/arm64-v8a/include/libavformat/dv.h
cp ffmpeg/libavformat/isom.h ffmpeg/build/arm64-v8a/include/libavformat/isom.h
cp ffmpeg/libavformat/dv.h ffmpeg/build/armeabi-v7a/include/libavformat/dv.h
cp ffmpeg/libavformat/isom.h ffmpeg/build/armeabi-v7a/include/libavformat/isom.h
cp ffmpeg/libavformat/dv.h ffmpeg/build/x86/include/libavformat/dv.h
cp ffmpeg/libavformat/isom.h ffmpeg/build/x86/include/libavformat/isom.h
cp ffmpeg/libavformat/dv.h ffmpeg/build/x86_64/include/libavformat/dv.h
cp ffmpeg/libavformat/isom.h ffmpeg/build/x86_64/include/libavformat/isom.h
