import QtQuick 2.3
import QtQuick.Window 2.2
import QuickIOS 0.1

Window {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    NavigationBar{
        id : navBar
        title: navigation.title
        backStage: navigation.views.length > 1
        onLeftClicked: navigation.pop(true);
    }

    Component {
        id: rootView
        Item {
            property var navigationItem : NavigationItem {
                title : "Quick iOS Example Program"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    navigation.push(Qt.resolvedUrl("alertview/AlertViewDemo.qml"));
                }
            }

            Text {
                text: qsTr("Press for next content view")
                anchors.centerIn: parent
            }
        }
    }

    NavigationView {
        id : navigation
        anchors.top: navBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

    }

    Component.onCompleted: {
        navigation.push(rootView,false);
    }

}
