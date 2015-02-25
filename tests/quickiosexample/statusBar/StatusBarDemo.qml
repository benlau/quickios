import QtQuick 2.0
import QuickIOS 0.1

ViewController {
    id : viewController
    title: "Status Bar Demo"

    prefersStatusBarHidden: true

    Column {
        anchors.centerIn: parent

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

        }

        BarButtonItem {
            title : "Close"
            onClicked: {
                viewController.dismissViewController();
            }
        }
    }

}

