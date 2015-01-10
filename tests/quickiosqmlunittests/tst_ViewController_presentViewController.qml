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
        anchors.fill: parent
        tintColor : "#00ff00"
        initialViewController: ViewController {
            id: rootView
            title: "Root View"

            navigationItem: NavigationItem {
            }
        }
    }

    Component {
        id : overlayView
        NavigationController {
            color: "black"
        }
    }

    TestCase {
        name: "ViewController_presentViewController"
        when : windowShown

        function test_preview() {
            wait(1000);
            var view = overlayView.createObject();
            rootView.presentViewController(view);
            compare(view.width,480);
            compare(view.height,640);
            compare(view.x,0);
            compare(view.y,640);
            compare(view.tintColor,"#00ff00");
            wait(1000);
            compare(view.x,0);
            compare(view.y,0);
            compare(view.width,480);
            compare(view.height,640);
            view.dismissViewController();

            wait(1000);
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
            wait(1000);
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

//            wait(TestEnv.waitTime);

        }
    }

}

