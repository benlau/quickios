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

    Component {
        id : viewControllerCreator2

        ViewController {
            id : controller
            anchors.fill: parent
            color : "green"

            Component.onCompleted: {
//                console.log("completed");
            }

            Component.onDestruction: {
//                console.log("destroyed")
//                window.destructionCount++;
            }
        }
    }

    TestCase {
        name: "NavigationController_gc"
        when : windowShown

        function test_pushComponentSource() {
            var destructionCount = 0;
            var navigationController = navigationControllerCreator.createObject(window);

            for (var i = 0 ; i < 5 ; i++) {
                var view = viewControllerCreator1.createObject();
                view.Component.onDestruction.connect(function() {
                    destructionCount++;
                });
                navigationController.push(view);
                view = undefined; // Set null can not clear the reference count  (Tested with Qt 5.4.1)
                wait(500);
                navigationController.pop();
                wait(500);
            }

            gc();
            compare(destructionCount,5);
            navigationController.destroy();
        }

        function test_pushStringSource() {
            var destructionCount = 0;
            var navigationController = navigationControllerCreator.createObject(window);

            for (var i = 0 ; i < 5 ; i++) {
                var view = navigationController.push(Qt.resolvedUrl("./SampleView.qml"));
                view.Component.onDestruction.connect(function() {
                    destructionCount++;
                });
                view = undefined;
                wait(500);
                navigationController.pop();
                wait(500);
            }

            gc();
            compare(Math.abs(destructionCount - 5) <= 1, true);
            // Qt 5.3.2 - The last ViewController object can not be destroyed in this turn.
            navigationController.destroy();
        }

        function test_pushComponentSourceNested() {

            var destructionCount = 0;
            var navigationController = navigationControllerCreator.createObject(window);

            for (var i = 0 ; i < 5 ; i++) {
                var view = viewControllerCreator1.createObject();
                view.Component.onDestruction.connect(function() {
                    destructionCount++;
                });

                navigationController.push(view);
                wait(500);

                view = viewControllerCreator2.createObject();
                view.Component.onDestruction.connect(function() {
                    destructionCount++;
                });

                navigationController.push(view);
                view = undefined;
                wait(500);

                navigationController.pop();
                wait(500);

                navigationController.pop();
                wait(500);
            }

            gc();
            compare(destructionCount,10);
            navigationController.destroy();
        }

    }


}
