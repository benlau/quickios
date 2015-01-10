import QtQuick 2.0
import QuickIOS 0.1
import QtQuick.Controls 1.2

ViewController {
    width: 100
    height: 62
    color : "#ffffff"
    title : "Alert Example Code"

    property var navigationItem : NavigationItem {
//        rightBar : BarButtonItem {
//            title: "Alert"
//            onClicked: {
//                alert.open();
//            }
//        }
        rightBarButtonItems : VisualItemModel {
            BarButtonItem {
                title: "Btn1"
                onClicked: {
                    alert.open();
                }
            }

            BarButtonItem {
                title: "Btn2"
                onClicked: {
                    alert.open();
                }
            }

        }
        leftBarButtonItem : BarButtonItem {
            title: "Alert"
            onClicked: {
                alert.open();
            }
        }
    }

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
