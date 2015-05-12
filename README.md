Quick iOS - QML Theme and Component Library for iOS
===================================================

[![Build Status](https://api.travis-ci.org/hilarycheng/quickios.svg)](https://travis-ci.org/hilarycheng/quickios)

The project is still under development.

Application Delegate
--------------------
Qt was implemented the Application Delegate in order to handle the iOS Entry Point. But it makes trouble if you needs to get information at the Application Delegate. Here are the suggestion:

 1. Use the idea from [colede/qt-app-delegate](https://github.com/colede/qt-app-delegate) to overwrite the Application Delegate. But you cannot get the information from didFinishLaunchingWithOptions.
 2. Simply copy the required source from qtbase/src/plugins/platforms/ios/. It don't need to copy all the source from it. Since iOS are static ELF. It simply overwrite the original object file during linking.

Simulted iOS Components
-----------------------

    UINavigationViewController , UITabViewController, UINavigationItem , UIBarButtonItem
    UISegmentedControl , UIAlertView


Demonstration
-------------

An example program is available in the folder of [tests/quickiosexample](tests/quickiosexample)

![Screenshot](https://raw.githubusercontent.com/benlau/quickios/master/docs/example.jpg)


Reference
---------

Other Qt iOS Projects

 1. [colede/qt-app-delegate](https://github.com/colede/qt-app-delegate)
 
Qt for Android

 1. [benlau/quickandroid](https://github.com/benlau/quickandroid)
