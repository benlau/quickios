import QtQuick 2.0
import QtQuick.Window 2.2
import QtTest 1.0
import QtQml.Models 2.1
import QuickIOS 0.1
import QuickIOS.utils 0.1


Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    property int destructionCount : 0

    Component{
        id: navigationControllerCreator

        NavigationController {
            id : navigationView
            anchors.fill: parent

            tintColor: "#00ff00"

            navigationBar.titleAttributes: NavigationBarTitleAttributes {
                textColor : "#ff0000"
            }

            initialViewController : ViewController {
                    id: rootView
                    title : "Quick iOS Example Program"

            }
        }

    }

    Component {
        id : viewControllerCreator1

        ViewController {
            id : controller
            anchors.fill: parent
            color : "red"

            Component.onCompleted: {
//                console.log("completed");
            }

            Component.onDestruction: {
//                console.log("destroyed")
                window.destructionCount++;
            }
        }
    }

    TestCase {
        name: "NavigationController_gc"
        when : windowShown

        function test_pushComponetSource() {
            var navigationController = navigationControllerCreator.createObject(window);

            for (var i = 0 ; i < 5 ; i++) {
                var view = viewControllerCreator1.createObject();
                navigationController.push(view);
                view = undefined; // Set null can not clear the reference count  (Tested with Qt 5.4.1)
                wait(500);
                navigationController.pop();
                wait(500);
            }

            gc();
            compare(window.destructionCount,5);
            navigationController.destroy();
        }

    }


}
