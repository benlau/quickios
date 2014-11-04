#!/bin/bash
#

export ASSETCATALOG_COMPILER_APPICON_NAME="AppIcon"
export ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME="LaunchImage"

if [ ! -d "build" ]; then
  mkdir build
fi

cd build
~/Qt5.3.2/5.3/ios/bin/qmake quickiosexample.pro
