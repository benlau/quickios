import QtQuick 2.0
import QuickIOS 0.1

Rectangle {
    width: 100
    height: 62
    color : "#ffffff"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            alert.open();
        }
    }

    Text {
        text: qsTr("Press to launch Alert View")
        anchors.centerIn: parent
    }

    IAlertView {
        id: alert
        title : "Example Dialog"
        message: "It is an example dialog. Press any button to quit."
        buttons : [qsTr("Cancel"),qsTr("OK")]
        onClicked : {
            console.log("Clicked button : ",buttonIndex);
        }
    }
}
