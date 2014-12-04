import QtQuick 2.0
import QtQuick.Window 2.2
import QuickIOS 0.1
import QtTest 1.0

Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    NavigationBar {
        id : navBar
        views: navigation.views
        onLeftClicked: navigation.pop(true);
        titleAttributes: NavigationBarTitleAttributes {
            textColor : "#ff0000"
        }
    }

    NavigationView {
        id : navigation
        anchors.top: navBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        initialView : Item {
                id: rootView

                property var navigationItem : NavigationItem {
                    title : "Quick iOS Example Program"
                }

                property string title : "Title"

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

//    Component.onCompleted: {
//        navigation.push(rootView,false);
//    }

    TestCase {
        name: "NavigationViewTests"
        when : windowShown

        function test_initialView() {
            compare(navBar.views.count , 1);
//            wait(60000);
        }

        function test_demo() {
            // Just demo the look and feel.
            // It don't do any checking yet
//            wait(60000);
            wait(1000);
        }
    }


}
