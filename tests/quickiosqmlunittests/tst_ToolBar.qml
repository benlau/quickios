import QtQuick 2.0
import QtTest 1.0
import QuickIOS 0.1
import QtQuick.Layouts 1.1

NavigationController {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true
    tintColor : "#ff0000"
    objectName: "Navigation Controller"

    initialViewController : ViewController {
        id: rootView
        title : "Tool Bar Test"

        toolBarItems : RowLayout {
            property color tintColor : window.tintColor

            BarButtonItem {
                id: newButton
                image : "./img/ic_play.png"
                Layout.alignment: Qt.AlignHCenter
                imageSourceSize: Qt.size(25,25)
            }

            BarButtonItem {
                title: "Trash"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Ruler {
            anchors.fill: parent
            orientation: Qt.Vertical
        }
    }


    TestCase {
        name: "ToolBar"
        when : windowShown

        function test_preview() {
            compare(rootView.toolBar.height,44);
            compare(window.toolBar.height,0);

            wait(TestEnv.waitTime);
        }
    }


}
