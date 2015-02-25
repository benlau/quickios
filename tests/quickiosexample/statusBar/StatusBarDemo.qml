import QtQuick 2.0
import QuickIOS 0.1

ViewController {
    id : viewController
    title: "Status Bar Demo"

    prefersStatusBarHidden: true

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode : Text.WordWrap
            text: "{ prefersStatusBarHidden : true }"
        }

        BarButtonItem {
            title : "Close"

            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                viewController.dismissViewController();
            }
        }
    }

}

