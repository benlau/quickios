import QtQuick 2.0
import QtQuick.Window 2.2
import QtTest 1.0
import QuickIOS.priv 0.1
import QuickIOS 0.1
import QtQuick.Controls 1.2
import QtQuick.Controls 1.2 as Quick

Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    Quick.TabView {
        anchors.fill: parent
        style : SegmentedControlTabViewStyle {
            count : 2
        }

        Tab {
            title : "red"
            Rectangle {
                color : "red"
            }
        }
        Tab {
            title : "blue"
            Rectangle {
                color : "blue"
            }
        }

    }

    TestCase {
        name: "SegmentedControlTabViewStyle"
        when : windowShown

        function test_demo() {
            // Just demo the look and feel.
            // It don't do any checking yet
//            wait(60000);
            wait(1000);
        }
    }


}
