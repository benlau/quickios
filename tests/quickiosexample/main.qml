import QtQuick 2.3
import QtQuick.Window 2.2
import QuickIOS 0.1

Window {

    NavigationBar{
        title: "Quick iOS Example Program"
    }

    visible: true

    MouseArea {
        anchors.fill: parent
        onClicked: {
            System.sendMessage("createAlertView",{});
        }
    }

    Text {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }
}
