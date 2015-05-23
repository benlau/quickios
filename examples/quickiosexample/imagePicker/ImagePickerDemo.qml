import QtQuick 2.0
import QuickIOS 0.1
import QtQuick.Layouts 1.1

ViewController {
    id : view
    title : "Image Picker"
    color : "black"

    toolBarItems: RowLayout {
        property color tintColor : view.tintColor
        anchors.fill: parent

        BarButtonItem {
            title : "Camera"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked : {
                picker.sourceType = ImagePicker.Camera
                picker.show();
            }

        }

        BarButtonItem {
            title : "Photo Library"
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            onClicked : {
                picker.sourceType = ImagePicker.PhotoLibrary
                picker.show(false);
            }
        }

        BarButtonItem {
            title : "Saved Album"
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            onClicked : {
                picker.sourceType = ImagePicker.PhotoLibrary
                picker.show();
            }
        }
    }

    Image {
        id : image
        anchors.fill: parent
        fillMode : Image.PreserveAspectFit
    }

    ImagePicker {
        id: picker

        onReady: {
            if (status === ImagePicker.Ready) {
                image.source = "";
                picker.busy = true;
                picker.saveAsTemp();
            }
        }

        onSaved: {
            console.log("The image is saved to " + url);
            image.source = url;
            picker.close();
            picker.busy = false;
        }
    }

}

