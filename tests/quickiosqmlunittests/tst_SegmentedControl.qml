import QtQuick 2.0
import QtQuick.Window 2.2
import QtTest 1.0
import QuickIOS 0.1
import QtQuick.Controls 1.2
import QtQuick.Controls 1.2 as Quick
import QtQml.Models 2.1

ViewController {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true
    tintColor : "#000000"

    SegmentedControl {
        id: segmentedControl
        anchors.fill: parent

        items : ObjectModel {

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
    }

    TestCase {
        name: "SegmentedControl"
        when : windowShown

        function test_preview() {
            // Just demo the look and feel.
            // It don't do any checking yet
            compare(segmentedControl.tintColor,"#000000");

            wait(TestEnv.waitTime);
        }
    }


}
