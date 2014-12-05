import QtQuick 2.0
import QtQuick.Window 2.2
import QuickIOS 0.1
import QtTest 1.0

Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    NavigationView {
        id : navigationView
        anchors.fill: parent
        navigationBar.titleAttributes: NavigationBarTitleAttributes {
            textColor : "#ff0000"
        }

        initialView : Item {
                id: rootView

                // It will be set automatically
                property var navigationView;

                property NavigationItem navigationItem : NavigationItem {
                    title : "Quick iOS Example Program"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        navigation.push(Qt.resolvedUrl("alertview/AlertViewDemo.qml"));
                    }
                }

                Text {
                    text: qsTr("Press for next content view")
                    anchors.centerIn: parent
                }
            }
    }

    Component {
        id: secondView
        Item {
            property int fieldA : 0
            property var navigationView;

            property NavigationItem navigationItem : NavigationItem {
                title : "Second View"
            }
        }
    }

    NavigationView {
        id : navigationView2
        visible : false;
        anchors.fill: parent        
    }

    TestCase {
        name: "NavigationViewTests"
        when : windowShown

        function test_initialView() {
            compare(navigationView.navigationBar.views.count , 1);
            compare(rootView.navigationView , navigationView);

            navigationView.push(secondView,{fieldA : 10});
            wait(500);
            compare(navigationView.views.count , 2);
            var view = navigationView.views.get(1).object;
            compare(view.hasOwnProperty("fieldA"),true);
            compare(view.fieldA, 10);

            navigationView.pop();
            compare(navigationView.views.count , 1);
        }

        function test_pushUnknownView() {
            navigationView.push("not-existed.qml");
        }

        function test_pushFirstPage() {
            compare(navigationView2.views.count , 0);

            navigationView2.push(secondView);
            compare(navigationView2.views.count , 1);
            compare(navigationView2.navigationBar.views.count , 1);
            var view = navigationView2.views.get(0).object;
            compare(view.navigationView,navigationView2);

            navigationView2.push(secondView);
            compare(navigationView2.views.count , 2);
            compare(navigationView2.navigationBar.views.count , 2);
        }

        function test_demo() {
            // Just demo the look and feel.
            // It don't do any checking yet
//            wait(60000);
            wait(1000);
        }
    }


}
