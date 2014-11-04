#!/bin/bash
#

# You can debug the app from Command Line rather than Xcode
# Download http://github.com/phonegap/ios-deploy, run make , copy ios-deploy to /usr/local/bin/
# After running make at the Qt, then run the ios-deploy with "-b" and "-d"

PROJECT_NAME=quickiosexample

make
RESULT=$?
if [ $RESULT -eq 0 ]; then
  /usr/local/bin/ios-deploy -b Debug-iphoneos/${PROJECT_NAME}.app -d
fi
