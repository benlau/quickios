import QtQuick 2.3
import QtQuick.Window 2.2
import QuickIOS 0.1

Window {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    Component {
        id: rootView
        ViewController {
            title : "Quick iOS Example Program"

            navigationItem : NavigationItem {
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    navigationController.push(Qt.resolvedUrl("alertview/AlertViewDemo.qml"));
                }
            }

            Text {
                text: qsTr("Press for next content view")
                anchors.centerIn: parent
            }
        }
    }

    NavigationController {
        id : navigation
        navigationBar.titleAttributes: NavigationBarTitleAttributes {
            textColor : "#ff0000"
        }
        anchors.fill: parent
    }

    Component.onCompleted: {
        navigation.push(rootView,false);
    }

}
