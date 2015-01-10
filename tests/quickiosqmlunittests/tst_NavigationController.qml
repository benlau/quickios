import QtQuick 2.0
import QtQuick.Window 2.2
import QuickIOS 0.1
import QtTest 1.0

Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    NavigationController {
        id : navigationView
        anchors.fill: parent
        navigationBar.titleAttributes: NavigationBarTitleAttributes {
            textColor : "#ff0000"
        }

        initialView : ViewController {
                id: rootView

                navigationItem : NavigationItem {
                    title : "Quick iOS Example Program"
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
        anchors.right: parent.right
        anchors.rightMargin: 0
        width: 12
        height: 44
        orientation: Qt.Horizontal
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

            property NavigationItem navigationItem : NavigationItem {
                title : "Second View"
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
            property NavigationItem navigationItem : NavigationItem {
                title : "Example View"
                leftBarButtonItem: BarButtonItem {
                    title: "Cancel"
                    Ruler {
                        anchors.fill: parent
                        orientation: Qt.Horizontal
                    }
                }
                rightBarButtonItem: BarButtonItem {
                    title: "OK"
                    Ruler {
                        anchors.fill: parent
                        orientation: Qt.Horizontal
                    }
                }

            }
        }
    }


    TestCase {
        name: "NavigationController"
        when : windowShown

        function test_initialView() {
            compare(navigationView.navigationBar.views.count , 1);
            compare(rootView.navigationView , navigationView);
            compare(rootView.willAppearCount , 1);
            compare(rootView.didAppearCount , 1);

            navigationView.push(viewWithTitleOnly,{fieldA : 10});
            wait(500);
            compare(navigationView.views.count , 2);
            var view = navigationView.views.get(1).object;
            compare(view.hasOwnProperty("fieldA"),true);
            compare(view.fieldA, 10);

            navigationView.pop();
            compare(navigationView.views.count , 1);
        }

        function test_pushUnknownView() {
            console.log("Expected fail condition: ")
            navigationView.push("not-existed.qml");
        }

        function test_pushFirstPage() {
            navigationView2.visible = true;
            compare(navigationView2.views.count , 0);

            navigationView2.push(viewWithTitleOnly);
            compare(navigationView2.views.count , 1);
            compare(navigationView2.navigationBar.views.count , 1);

            var view = navigationView2.views.get(0).object;
            compare(view.navigationView,navigationView2);
//            compare(view.width,480);

            navigationView2.push(viewWithTitleOnly);
            compare(navigationView2.views.count , 2);
            compare(navigationView2.navigationBar.views.count , 2);

            wait(TestEnv.waitTime);
            navigationView2.visible = false;
        }

        function test_viewWithTitleAndLeftRightButton() {
            navigationView2.push(viewWithTitleAndLeftRightButton);
            navigationView2.visible = true;
            wait(TestEnv.waitTime);
            navigationView2.pop();
            navigationView2.visible = false;

        }

        function test_demo() {
            // Just demo the look and feel.
            // It don't do any checking yet
//            wait(60000);
            wait(TestEnv.waitTime);
        }
    }


}
