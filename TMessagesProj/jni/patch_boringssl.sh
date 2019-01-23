#!/bin/bash

set -e

patch -d boringssl -p1 < patches/boringssl/0001-add-aes-ige-mode.patch
patch -d boringssl -p1 < patches/boringssl/0001-only-build-what-we-need.patch
patch -d libtgvoip -p1 < patches/libtgvoip/0001-work-with-boringssl.patch
