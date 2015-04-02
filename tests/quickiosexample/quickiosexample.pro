TARGET = QuickIOSExample
TEMPLATE = app

QT += qml quick

SOURCES += main.cpp

ios {
    OBJECTIVE_SOURCES += \
            appdelegate.mm
}

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

include(../../quickios.pri)

QMAKE_IOS_DEPLOYMENT_TARGET = 7.0
QMAKE_TARGET_BUNDLE_PREFIX = com.github
QMAKE_IOS_TARGETED_DEVICE_FAMILY = 1,2

#QMAKE_CXXFLAGS += -fobjc-arc
QMAKE_CFLAGS += -fobjc-arc

HEADERS += \
    elcimagepicker/Classes/ELCImagePicker/ELCAlbumPickerController.h \
    elcimagepicker/Classes/ELCImagePicker/ELCAsset.h \
    elcimagepicker/Classes/ELCImagePicker/ELCAssetCell.h \
    elcimagepicker/Classes/ELCImagePicker/ELCAssetPickerFilterDelegate.h \
    elcimagepicker/Classes/ELCImagePicker/ELCAssetSelectionDelegate.h \
    elcimagepicker/Classes/ELCImagePicker/ELCAssetTablePicker.h \
    elcimagepicker/Classes/ELCImagePicker/ELCConsole.h \
    elcimagepicker/Classes/ELCImagePicker/ELCImagePickerController.h \
    elcimagepicker/Classes/ELCImagePicker/ELCImagePickerHeader.h \
    elcimagepicker/Classes/ELCImagePicker/ELCOverlayImageView.h

OBJECTIVE_SOURCES += \
    elcimagepicker/Classes/ELCImagePicker/ELCAlbumPickerController.m \
    elcimagepicker/Classes/ELCImagePicker/ELCAsset.m \
    elcimagepicker/Classes/ELCImagePicker/ELCAssetCell.m \
    elcimagepicker/Classes/ELCImagePicker/ELCAssetTablePicker.m \
    elcimagepicker/Classes/ELCImagePicker/ELCConsole.m \
    elcimagepicker/Classes/ELCImagePicker/ELCImagePickerController.m \
    elcimagepicker/Classes/ELCImagePicker/ELCOverlayImageView.m

elcimagepicker.files += \
    $$PWD/elcimagepicker/Classes/ELCImagePicker/Resources/Overlay.png \
    $$PWD/elcimagepicker/Classes/ELCImagePicker/Resources/Overlay@2x.png \
    $$PWD/elcimagepicker/Classes/ELCImagePicker/Resources/ELCAlbumPickerController.xib \
    $$PWD/elcimagepicker/Classes/ELCImagePicker/Resources/ELCAssetPicker.xib \
    $$PWD/elcimagepicker/Classes/ELCImagePicker/Resources/ELCAssetTablePicker.xib

QMAKE_BUNDLE_DATA += elcimagepicker

QMAKE_LFLAGS += -framework AssetsLibrary -framework CoreLocation -framework MobileCoreServices


