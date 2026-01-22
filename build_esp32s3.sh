#!/bin/bash

# This script builds the pico-fido firmware for the ESP32-S3 platform on a debian or ubuntu system

set -euxo pipefail
VERSION_MAJOR="7"
VERSION_MINOR="2"
SUFFIX="${VERSION_MAJOR}.${VERSION_MINOR}"
#TS=$(date --utc +%Y-%m-%d)

git submodule update --init --recursive

sudo apt update
sudo apt install -y git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

git clone https://github.com/espressif/esp-idf.git
cd esp-idf
git checkout tags/v5.5
git submodule update --init --recursive
./install.sh esp32s3
. ./export.sh
cd ..

idf.py set-target esp32s3
idf.py all
mkdir -p release
cd build
esptool.py --chip ESP32-S3 merge_bin -o ../release/pico_fido_${SUFFIX}_esp32-s3.bin @flash_args
cd ..
