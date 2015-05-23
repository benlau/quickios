#-------------------------------------------------
#
# Project created by QtCreator 2014-11-24T16:10:59
#
#-------------------------------------------------

QT       += testlib

QT       -= gui

TARGET = tst_quickiosunittests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += tst_quickiosunittests.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"
RESOURCES += ../../examples/quickiosexample/qml.qrc
include (../../quickios.pri)
