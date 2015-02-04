TARGET = QuickIOSExample
TEMPLATE = app

QT += qml quick

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

include(../../quickios.pri)

# Default rules for deployment.
include(deployment.pri)

QMAKE_IOS_DEPLOYMENT_TARGET = 7.0
QMAKE_TARGET_BUNDLE_PREFIX = com.github
QMAKE_IOS_TARGETED_DEVICE_FAMILY = 1,2
