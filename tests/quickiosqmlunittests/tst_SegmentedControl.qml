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

    property ViewControllerListener listener1;
    property ViewControllerListener listener2;

    initialViewController: ViewController {
        id: viewController
        title : "Segmented Control"

        SegmentedControl {
            id: segmentedControl
            anchors.fill: parent

            Segment {
                title : "red"
                ViewController {
                    id : view1
                    color : "red"

                    ViewControllerListener{
                        id : listenerA;
                        viewController: view1
                    }

                    Component.onCompleted: {
                        listener1 = listenerA;
                    }
                }
            }

            Segment {
                title : "blue"
                ViewController {
                    id : view2
                    color : "blue"

                    ViewControllerListener {
                        id : listenerB;
                        viewController: view2
                    }

                    Component.onCompleted: {
                        listener2 = listenerB;
                    }
                }
            }

        }
    }

    TestCase {
        name: "SegmentedControl"
        when : windowShown

        function test_preview() {
            compare(segmentedControl.tintColor,"#000000");
            compare(segmentedControl.numberOfSegments,2)
            compare(segmentedControl.selectedSegmentIndex , 0);

            var view1 = segmentedControl.itemAt(0);
            compare(view1.tintColor, "#000000");
            compare(viewController.navigationController , window);
            compare(viewController.navigationController , view1.navigationController);

            compare(listener1.willAppearCount , 1);
            compare(listener1.didAppearCount , 1);

            segmentedControl.selectedSegmentIndex = 1;

            compare(listener1.willDisappearCount , 1);
            compare(listener1.didDisappearCount , 1);

            var view2 = segmentedControl.itemAt(1);
            compare(view2.tintColor, "#000000")

            compare(listener2.willAppearCount , 1);
            compare(listener2.didAppearCount , 1);

            wait(100);
            segmentedControl.selectedSegmentIndex = 0;

            compare(listener2.willAppearCount , 1);
            compare(listener2.didAppearCount , 1);
            compare(listener2.willDisappearCount , 1);
            compare(listener2.didDisappearCount , 1);

            compare(listener1.willAppearCount , 2);
            compare(listener1.didAppearCount , 2);
            compare(listener1.willDisappearCount , 1);
            compare(listener1.didDisappearCount , 1);

            segmentedControl.selectedSegmentIndex = 0;

            compare(listener2.willAppearCount , 1);
            compare(listener2.didAppearCount , 1);
            compare(listener2.willDisappearCount , 1);
            compare(listener2.didDisappearCount , 1);

            compare(listener1.willAppearCount , 2);
            compare(listener1.didAppearCount , 2);
            compare(listener1.willDisappearCount , 1);
            compare(listener1.didDisappearCount , 1);


            wait(TestEnv.waitTime);
        }
    }


}
