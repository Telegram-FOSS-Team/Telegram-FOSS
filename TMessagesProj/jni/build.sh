test -d "$ANDROID_HOME" && ! test -f "$NDK" && export NDK="$ANDROID_HOME/ndk/$(ls "$ANDROID_HOME/ndk" | tail -1)"
export NINJA_PATH="$(command -v ninja)"
./build_ffmpeg_clang.sh
./patch_ffmpeg.sh
./patch_boringssl.sh
./build_boringssl.sh
