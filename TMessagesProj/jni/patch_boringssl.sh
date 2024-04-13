#!/bin/bash

set -e

patch -d boringssl -p1 < patches/boringssl/0001-add-aes-ige-mode.patch
patch -d boringssl -p1 < patches/boringssl/0001-do-not-build-tests.patch
