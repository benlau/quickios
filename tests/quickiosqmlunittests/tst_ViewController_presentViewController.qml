import QtQuick 2.0
import QtQuick.Window 2.2
import QtTest 1.0
import QuickIOS.priv 0.1
import QuickIOS 0.1
import QtQuick.Controls 1.2
import QtQuick.Controls 1.2 as Quick

Rectangle {
    width: 480
    height: 640

    NavigationController {
        id: navigationController
        anchors.fill: parent
        tintColor : "#00ff00"
        initialViewController: ViewController {
            id: rootView
            title: "Root View"

            navigationItem: NavigationItem {
            }
        }
    }

    property int didDisappearCount : 0
    property int willDisappearCount : 0
    property int willAppearCount : 0
    property int didAppearCount : 0

    Component {
        id : overlayView
        NavigationController {
            color: "black"

            onViewWillAppear: {
                willAppearCount++;
            }
            onViewDidAppear: {
                didAppearCount++;
            }
            onViewWillDisappear: willDisappearCount++;
            onViewDidDisappear:  didDisappearCount++
        }
    }

    Component {
        id : sampleViewController

        ViewController {
            property int clickedCount;

            Text {
                anchors.centerIn: parent
                text : "Sample View Controller";
            }

            MouseArea {
                anchors.fill: parent
                onClicked : {
                    clickedCount++;
                    console.log(clickedCount);
                }
            }
        }
    }

    TestCase {
        name: "ViewController_presentViewController"
        when : windowShown

        function test_preview() {
            wait(500);
            var view = overlayView.createObject();
            compare(didAppearCount,0);
            compare(willAppearCount,0);
            compare(didDisappearCount,0);
            compare(willDisappearCount,0);

            rootView.presentViewController(view);

            compare(didAppearCount,0);
            compare(willAppearCount,1);
            compare(didDisappearCount,0);
            compare(willDisappearCount,0);

            compare(view.width,480);
            compare(view.height,640);
            compare(view.x,0);
            compare(view.y,640);
            compare(view.tintColor,"#00ff00"); // Inherit the tintColor from navigationController.

            wait(500);

            compare(didAppearCount,1);
            compare(willAppearCount,1);
            compare(didDisappearCount,0);
            compare(willDisappearCount,0);

            compare(rootView.enabled , false);
            compare(view.parent !== rootView, true);

            compare(view.x,0);
            compare(view.y,0);
            compare(view.width,480);
            compare(view.height,640);

            view.dismissViewController();

            compare(didAppearCount,1);
            compare(willAppearCount,1);
            compare(didDisappearCount,0);
            compare(willDisappearCount,1);

            wait(500);
            compare(rootView.enabled , true);

            compare(didAppearCount,1);
            compare(willAppearCount,1);
            compare(didDisappearCount,1);
            compare(willDisappearCount,1);

            compare(view.width,480);
            compare(view.height,640);
            compare(view.x,0);
            compare(view.y,640);

            wait(500);

            var view2 = rootView.present(Qt.resolvedUrl("./SampleView.qml"),{ color : "red"}) ;
            compare(view2 !== undefined,true);
            compare(view2!==view , true);

            compare(view2.width,480);
            compare(view2.height,640);
            compare(view2.x,0);
            compare(view2.y,640);
            wait(500);
            compare(view2.x,0);
            compare(view2.y,0);
            compare(view2.width,480);
            compare(view2.height,640);
            view2.dismissViewController();

            wait(500);
            compare(view2.width,480);
            compare(view2.height,640);
            compare(view2.x,0);
            compare(view2.y,640);
            view2= null;
        }

        function test_nestedPresentViewController() {
            var view1 = overlayView.createObject();
            rootView.presentViewController(view1);
            compare(view1.enabled,true);

            wait(500);
            var view2 = sampleViewController.createObject();
            view1.presentViewController(view2);

            compare(view2.enabled,true);

//            wait(TestEnv.waitTime);

            view2.dismissViewController();

            wait(500);
            compare(view1.enabled,true);
            view1.dismissViewController();
            wait(500);

            didDisappearCount = 0;
            willDisappearCount = 0;
            willAppearCount = 0;
            didAppearCount = 0;
        }
    }

}

