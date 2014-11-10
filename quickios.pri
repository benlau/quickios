QT += qml quick widgets

QML_IMPORT_PATH += $$PWD

INCLUDEPATH += $$PWD

RESOURCES += $$PWD/QuickIOS/quickios.qrc

HEADERS += $$PWD/quickios.h \
    $$PWD/qisystemutils.h \
    $$PWD/qiviewdelegate.h \
    $$PWD/qialertview.h

SOURCES += $$PWD/quickios.cpp \
    $$PWD/qialertview.cpp

ios {
    OBJECTIVE_SOURCES += \
        $$PWD/qisystemutils.mm \
        $$PWD/qiviewdelegate.mm

    #Qt Quick Controls
    QTPLUGIN += qtquickcontrolsplugin

    # Fix for linking issues for Qt 5.3.2
    QTQUICKCONTROLS_LIBS = -L$$clean_path($$QMAKESPEC/../../qml/QtQuick/Controls)
    LIBS += $$QTQUICKCONTROLS_LIBS

} else {

    SOURCES += $$PWD/qisystemutils.cpp
}
