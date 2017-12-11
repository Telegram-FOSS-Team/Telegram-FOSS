#!/bin/bash

#fail on error
set -e

pkgnames=(   libwebp openssl sqlite-autoconf ffmpeg )
pkgvers=(    0.6.0   1.0.2o  3230100         3.0 )
extensions=( tar.gz  tar.gz  tar.gz          tar.xz )
shasum=(     skip    skip    92842b283e5e744eff5da29ed3c69391de7368fccc4d0ee6bf62490ce555ef25 skip )
link=(       "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/" "https://www.openssl.org/source/" "https://sqlite.org/2018/" "https://ffmpeg.org/releases/" )
nopackages=${#pkgnames[@]}

OPTIND=1
clean=0

function usage (){
  echo -e "Usage: $0 [-c] \n\t -c\tClean everything."
}

function die() { echo "$@" 1>&2 ; exit 1; }

while getopts "h?c" opt; do
  case "$opt" in
  h|\?)
      usage
      exit 0
      ;;
  c)  clean=1
      ;;
  *)
      usage
      exit 1
      ;;
  esac

done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

function chdir (){
  # Get absolute path to script.
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

  # Then change to parent dir.
  pushd "$DIR" > /dev/null
}

function download () {
  mkdir -p "3rdParty/download"
  if [ ! -f "3rdParty/download/$2" ]; then
    echo "Downloading missing 3rdParty/download/$2 from $1$2"
    curl -o "3rdParty/download/$2" -L "$1$2" > /dev/null 2>&1
    curl -o "3rdParty/download/$2.sig" --fail -L "$1$2.sig" >/dev/null 2>&1 || curl -o "3rdParty/download/$2.asc" --fail -L "$1$2.asc" > /dev/null 2>&1 || echo "No signature file found for $2"
  fi
}

function verify () {
  # Try to verify gpg signature. Lacking that try to verify shasum
  echo "Verifying 3rdParty/download/$1"
  gpg --homedir "$g" --verify "3rdParty/download/$1.sig" 2> /dev/null \
    || gpg --homedir "$g" --verify "3rdParty/download/$1.asc" 2> /dev/null \
    || { echo "No gpg signature for $1, trying shasum" \
         && if [ "$2" == "skip" ]; then \
              die "NO valid signature or hashsum provided."; \
            else echo -e "$2\t3rdParty/download/$1" | sha256sum -c -; fi \
        } \
    || die "INVALID signature/hash! Download corrupted? Has the signing key changed?"
}

function extract () {
  echo "Extracting 3rdParty/download/$1 into $2"
  rm -rf "$2"
  mkdir -p "$2"
  tar xf "3rdParty/download/$1" -C "$2" --strip-components=1
}

function clean () {
  echo "rm -f 3rdParty/download/*"
  rm -f 3rdParty/download/*
  for i in $(seq 0 $(( $nopackages - 1 )))
  do
    dirname="${pkgnames[$i]}"
    echo "rm -rf 3rdParty/unpacked/$dirname"
    rm -rf "3rdParty/unpacked/$dirname"
  done
}

function handle_libwebp () {
  echo "Preparing libwebp source tree in TMessagesProj/jni/libwebp/"
  rm -rf TMessagesProj/jni/libwebp/
  cp -r  3rdParty/unpacked/libwebp TMessagesProj/jni/libwebp
}

function handle_ffmpeg () {
  echo "Preparing ffmpeg source tree in TMessagesProj/jni/ffmpeg/"
  rm -rf TMessagesProj/jni/ffmpeg/libav* TMessagesProj/jni/ffmpeg/compat
  pushd 3rdParty/unpacked/ffmpeg > /dev/null
  cp -r libavcodec libavformat libavutil compat ../../../TMessagesProj/jni/ffmpeg
  cp COPYING* CREDITS LICENSE.md README.md Changelog ../../../TMessagesProj/jni/ffmpeg
  popd > /dev/null
}

function handle_openssl () {
  echo "Preparing openssl source tree in TMessagesProj/jni/openssl/"
  rm -rf TMessagesProj/jni/openssl/crypto
  pushd 3rdParty/unpacked/openssl > /dev/null
  cp -r crypto CHANGES e_os2.h e_os.h LICENSE README ../../../TMessagesProj/jni/openssl
  popd > /dev/null
}

function handle_sqlite () {
  echo "Preparing sqlite sources in TMessagesProj/jni/sqlite"
  pushd 3rdParty/unpacked/sqlite-autoconf > /dev/null
  cp sqlite3.c sqlite3.h ../../../TMessagesProj/jni/sqlite
  popd > /dev/null
}

chdir
if [ $clean = 1 ]; then
  clean
else
  hash gpg 2>/dev/null || { echo >&2 "Please install gpg. Aborting."; exit 1; }
  echo "Importing maintainer gpg keys into temporary keyring."
  g=$(mktemp -d) && trap "rm -rf $g" EXIT || exit 255
  gpg --homedir "$g" --import "3rdParty/maintainer_keys/"*.asc
  for i in $(seq 0 $(( $nopackages - 1 )))
  do
    filename="${pkgnames[$i]}-${pkgvers[$i]}.${extensions[$i]}"
    download "${link[$i]}" "$filename"
    verify "$filename" "${shasum[$i]}"
    extract "$filename" 3rdParty/unpacked/"${pkgnames[i]}"
  done
  #handle_libwebp
  handle_openssl
  handle_sqlite
  #handle_ffmpeg
fi
popd > /dev/null
