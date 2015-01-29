import QtQuick 2.0
import QtTest 1.0
import QuickIOS 0.1
import QtQuick.Layouts 1.1

ViewController {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true
    tintColor : "#ff0000"

    toolBarItems : RowLayout {
        property color tintColor : window.tintColor

        BarButtonItem {
            id: newButton
            title: "New"
            Layout.alignment: Qt.AlignHCenter
        }

        BarButtonItem {
            title: "Trash"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Rectangle {
        color : "green"
        anchors.fill: parent
    }

    TestCase {
        name: "ToolBar"
        when : windowShown

        function test_preview() {
            wait(TestEnv.waitTime);
        }
    }


}
