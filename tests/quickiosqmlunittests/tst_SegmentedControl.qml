import QtQuick 2.0
import QtQuick.Window 2.2
import QtTest 1.0
import QuickIOS 0.1
import QtQuick.Controls 1.2
import QtQuick.Controls 1.2 as Quick
import QtQml.Models 2.1

NavigationController {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true
    tintColor : "#000000"

    initialViewController: ViewController {
        id: viewController
        title : "Segmented Control"

        SegmentedControl {
            id: segmentedControl
            anchors.fill: parent

            Segment {
                title : "red"
                ViewController {
                    color : "red"
                }
            }

            Segment {
                title : "blue"
                ViewController {
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
            compare(segmentedControl.numberOfSegments,2)
            compare(segmentedControl.selectedSegmentIndex , 0);

            var view1 = segmentedControl.itemAt(0);
            compare(view1.tintColor, "#000000");
            compare(viewController.navigationController , window);
            compare(viewController.navigationController , view1.navigationController);


            segmentedControl.selectedSegmentIndex = 1;

            var view2 = segmentedControl.itemAt(1);
            compare(view2.tintColor, "#000000")

            wait(TestEnv.waitTime);
        }
    }


}
