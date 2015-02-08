import QtQuick 2.0
import QtQuick.Window 2.2
import QuickIOS 0.1
import QtTest 1.0
import QtQml.Models 2.1

Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    NavigationController {
        // NavigationController with initialViewController
        id : navigationView
        anchors.fill: parent

        tintColor: "#00ff00"

        navigationBar.titleAttributes: NavigationBarTitleAttributes {
            textColor : "#ff0000"
        }

        initialViewController : ViewController {
                id: rootView
                title : "Quick iOS Example Program"

                navigationItem : NavigationItem {
                    leftBarButtonItem: BarButtonItem {
                        id : rootViewLeftButton
                        title: "Left"

                        Ruler {
                            anchors.fill: parent
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                }

                Text {
                    text: qsTr("Press for next content view")
                    anchors.centerIn: parent
                }

                property int willAppearCount : 0
                onViewWillAppear: {
                    willAppearCount++;
                }
                property int didAppearCount : 0
                onViewDidAppear: {
                    didAppearCount++;
                }
            }
    }

    NavigationController {
        // NavigationController without initialViewController
        id : navigationView2
        visible : false;
        anchors.fill: parent
    }


    Ruler {
        anchors.top:parent.top
        anchors.right: parent.right
        anchors.rightMargin: 80
        width: 20
        height: 44
        orientation: Qt.Vertical
    }

    Ruler {
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 120
        orientation: Qt.Horizontal
        height: 44
    }

    Component {
        id: viewWithTitleOnly
        ViewController {
            property int fieldA : 0
            title : "Second View"

            property NavigationItem navigationItem : NavigationItem {
            }

            Rectangle {
                color : "red"
                anchors.fill: parent
            }
        }
    }

    Component {
        id: viewWithTitleAndLeftRightButton
        ViewController {
            title : "Example View"

            property alias cancelButton : leftButton

            property NavigationItem navigationItem : NavigationItem {
                leftBarButtonItem: BarButtonItem {
                    id: leftButton
                    objectName : "LeftButton"

                    title: "Cancel"
                    Ruler {
                        anchors.fill: parent
                        orientation: Qt.Horizontal
                    }                    
                }
                rightBarButtonItem: BarButtonItem {
                    title: "OK"
                    objectName : "RightButton"
                    Ruler {
                        anchors.fill: parent
                        orientation: Qt.Horizontal
                    }
                }

            }
        }
    }

    Component {
        id: viewWithTitleAndLeftRightButtons
        ViewController {
            title : "Example View"

            property NavigationItem navigationItem : NavigationItem {
                leftBarButtonItems: ObjectModel {
                    BarButtonItem {
                        title: "Cancel1"
                        Ruler {
                            anchors.fill: parent
                            orientation: Qt.Horizontal
                        }
                    }
                    BarButtonItem {
                        title: "Cancel2"
                        Ruler {
                            anchors.fill: parent
                            orientation: Qt.Horizontal
                        }
                    }
                }
                rightBarButtonItems: VisualItemModel { // VisualItemModel also works
                    BarButtonItem {
                        title: "OK1"
                        Ruler {
                            anchors.fill: parent
                            orientation: Qt.Horizontal
                        }
                    }
                    BarButtonItem {
                        title: "OK2"
                        Ruler {
                            anchors.fill: parent
                            orientation: Qt.Horizontal
                        }
                    }
                }

            }
        }
    }

    Component {
        id: viewWithDynamicTitleAndButtons

        ViewController {
            id: view
            title : "Dynamic Title"

            navigationItem: mode0Item;
            property NavigationItem mode0Item  :NavigationItem {
                leftBarButtonItem: BarButtonItem {
                    title : "L1"
                }

                rightBarButtonItems: VisualItemModel {
                    BarButtonItem {
                       title : "R1"
                    }

                    BarButtonItem {
                       title : "R2"
                    }
                }
            }

            property NavigationItem mode1Item : NavigationItem {
                leftBarButtonItems: VisualItemModel {
                    BarButtonItem {
                        title : "L1"
                    }

                    BarButtonItem {
                        title : "L2"
                    }
                }

                rightBarButtonItem:  BarButtonItem {
                       title : "R1"
                }
            }

            property int mode : 0

            states: [
                State {
                    when: mode == 1;

                    PropertyChanges {
                        target: view
                        title : "Mode 1"
                        navigationItem: mode1Item
                    }

                }

            ]

        }
    }

    Component {
        id : viewWithCustomTintColor

        ViewController {
            title: "Custom tintColor"
            tintColor : "#333333"

            navigationItem: NavigationItem {
               leftBarButtonItem: BarButtonItem {
                    title: "Left";
                }

                rightBarButtonItem: BarButtonItem {
                    title: "Right";
                }
            }
        }
    }

    Component {
        id : hRuler
        Ruler {
            anchors.fill: parent
            orientation : Qt.Horizontal
        }
    }


    TestCase {
        name: "NavigationController"
        when : windowShown

        function test_initialViewController() { // Test NavigationController with initialViewController
            compare(navigationView.navigationBar.views.count , 1);
            compare(rootView.navigationController , navigationView);
            compare(rootView.willAppearCount >= 1 , true); // May be triggered by another test case.
            compare(rootView.didAppearCount >= 1 , true);
            compare(rootView.tintColor , "#00ff00");

            navigationView.push(viewWithTitleOnly,{fieldA : 10});
            wait(500);
            compare(navigationView.views.count , 2);
            var view = navigationView.views.get(1).object;
            compare(view.hasOwnProperty("fieldA"),true);
            compare(view.fieldA, 10);
            compare(view.tintColor , "#00ff00");

            navigationView.pop();
            wait(500);
            compare(navigationView.views.count , 1);

            navigationView.push(viewWithTitleAndLeftRightButton);
            wait(500);
            compare(navigationView.views.count , 2);

            view = navigationView.views.get(1).object;
            var leftItem = view.navigationItem.leftBarButtonItems.children[0];
            var rightItem = view.navigationItem.rightBarButtonItems.children[0];

            compare(leftItem.tintColor,"#00ff00");
            compare(rightItem.tintColor,"#00ff00");

            wait(500);
            navigationView.pop();

            wait(TestEnv.waitTime);
        }

        function test_pushUnknownView() {
            console.log("Expected fail condition: ")
            navigationView.push("not-existed.qml");
        }

        function test_pushFirstPage() {
            navigationView2.visible = true;
            compare(navigationView2.views.count , 0);

            navigationView2.push(viewWithTitleOnly);
            wait(500);

            compare(navigationView2.views.count , 1);
            compare(navigationView2.navigationBar.views.count , 1);

            var view = navigationView2.views.get(0).object;
            compare(view.navigationController,navigationView2);
            compare(view.width,480);
            compare(view.height,640 - 44);
            compare(view.navigationController,navigationView2);

            navigationView2.push(viewWithTitleOnly);
            var view2 = navigationView2.views.get(1).object
            compare(navigationView2.views.count , 2);
            compare(navigationView2.navigationBar.views.count , 2);
            compare(view2.navigationController,navigationView2);

            wait(TestEnv.waitTime);
            navigationView2.pop();

            navigationView2.visible = false;
        }

        function test_viewWithTitleAndLeftRightButton() {
            navigationView2.push(viewWithTitleAndLeftRightButton);
            navigationView2.visible = true;

            wait(500);
            var view = navigationView2.views.get(navigationView2.views.count -1 ).object;
            compare(view.cancelButton.height,44);

            var rightButton = TestEnv.findChild(navigationView2,"RightButton");
            var x = window.mapFromItem(rightButton,rightButton.x,rightButton.y).x;
            compare(x + rightButton.width,window.width);

            navigationView2.push(viewWithTitleAndLeftRightButton);
            wait(500);

            var leftButton = TestEnv.findChild(navigationView2.views.get(1).object,"LeftButton");
            compare(leftButton !== null , true);
            x = window.mapFromItem(leftButton,leftButton.x,leftButton.y).x;
            var backButton = TestEnv.findChild(window,"NavigationBarBackButton");
            compare(x,backButton.width);

            wait(TestEnv.waitTime);
            navigationView2.pop();

            navigationView2.pop();
            navigationView2.visible = false;
        }

        function test_viewWithTitleAndLeftRightButtons() {
            compare(navigationView.navigationBar.views.count , 1);
            navigationView.push(viewWithTitleAndLeftRightButtons);
            wait(500);

            var view = navigationView.views.get(1).object;

            wait(TestEnv.waitTime);

            navigationView.pop();
            wait(TestEnv.waitTime);

        }

        function test_changeTintColorDynamically() {
            navigationView.tintColor = "#333333";
            compare(rootViewLeftButton.tintColor,"#333333");
            navigationView.tintColor = "#00ff00";
            compare(rootViewLeftButton.tintColor,"#00ff00");
        }

        function test_dynamicTitleAndButtons() {
            compare(navigationView.navigationBar.currentLeftButtonItems.count,1);
            compare(navigationView.navigationBar.currentRightButtonItems.count,0);

            navigationView.push(viewWithDynamicTitleAndButtons);
            wait(500);

            var view = navigationView.views.get(1).object;
            compare(view.mode,0);
            compare(view.title , "Dynamic Title");
            compare(navigationView.navigationBar.currentTitle,view.title);
            compare(navigationView.navigationBar.currentLeftButtonItems.count,1);
            compare(navigationView.navigationBar.currentRightButtonItems.count,2);

            view.mode = 1;
            compare(view.title , "Mode 1");
            compare(navigationView.navigationBar.currentTitle,view.title);

            compare(navigationView.navigationBar.currentLeftButtonItems.count,2);
            compare(navigationView.navigationBar.currentRightButtonItems.count,1);

            view.mode = 0;
            compare(view.title , "Dynamic Title");
            compare(navigationView.navigationBar.currentTitle,view.title);

            wait(500);

            navigationView.push(viewWithTitleAndLeftRightButtons);
            var view2 = navigationView.views.get(2).object;

            compare(navigationView.navigationBar.currentLeftButtonItems.count,2);
            compare(navigationView.navigationBar.currentRightButtonItems.count,2);

            wait(500);
            navigationView.pop();

            wait(500);

            compare(navigationView.navigationBar.currentLeftButtonItems.count,1);
            compare(navigationView.navigationBar.currentRightButtonItems.count,2);

            view.mode = 1;

            compare(navigationView.navigationBar.currentLeftButtonItems.count,2);
            compare(navigationView.navigationBar.currentRightButtonItems.count,1);

            wait(TestEnv.waitTime);

            navigationView.pop();

            compare(navigationView.navigationBar.currentTitle,"Quick iOS Example Program");
        }

        function test_viewWithCustomTintColor() {
            navigationView.push(viewWithCustomTintColor);
            wait(500);
            var view = navigationView.navigationBar.views.get(1).object;
            compare(view.tintColor,"#333333");

            var nagivationItem = navigationView.navigationBar.navigationItem;
            var leftButton = navigationView.navigationBar.currentLeftButtonItems.children[0];

            compare(leftButton.tintColor,"#00ff00"); // The left right buttons should inherit from navigation controller.

            wait(TestEnv.waitTime);

            navigationView.pop();
            wait(500);
        }

        function test_pushObject() {
            var object = viewWithCustomTintColor.createObject(this);
            navigationView.push(object);
            wait(500);

            compare(navigationView.views.count,2);
            var view = navigationView.navigationBar.views.get(1).object;
            compare(view , object);

            navigationView.pop();
            wait(500);
        }

        function test_statusBar() {
            // test cases related to status bar
            navigationView.push(viewWithCustomTintColor);
            wait(500);

            var backButton = TestEnv.findChild(window,"NavigationBarBackButton");
            compare(backButton.enabled,true);

            var y = window.mapFromItem(backButton,backButton.x,backButton.y).y;
            compare(y,0);

            QIDevice.screenFillStatusBar = true;
            y = window.mapFromItem(backButton,backButton.x,backButton.y).y;
            compare(y,20);

            wait(TestEnv.waitTime);
            QIDevice.screenFillStatusBar = false;

            navigationView.pop();
            wait(500);
        }

        function test_topViewController() {
            compare(navigationView.topViewController,rootView);
            navigationView.push(viewWithCustomTintColor);

            compare(navigationView.topViewController !== rootView,true);

            var view = navigationView.topViewController;
            compare(view.tintColor,"#333333");

            navigationView.pop();

            compare(navigationView.topViewController,rootView);
        }

        function test_preview() {
            // Just test the dimen. And let user to try the component.
            var backButton = TestEnv.findChild(window,"NavigationBarBackButton");
            compare(backButton.enabled,false);

            var x = window.mapFromItem(rootViewLeftButton,rootViewLeftButton.x).x;
            compare(x,0);

            wait(TestEnv.waitTime);
        }

    }


}
