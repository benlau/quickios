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
            alert.open();
        }
    }

    Text {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }

    IAlertView {
        id: alert
        title : "Example Dialog"
        message: "It is an example dialog. Press any button to quit."
        buttons : ["Cancel","OK"]
        onClicked : {
            console.log("Clicked button : ",buttonIndex);
        }
    }
}
