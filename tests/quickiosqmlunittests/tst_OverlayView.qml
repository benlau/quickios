import QtQuick 2.0
import QtQuick.Window 2.2
import QuickIOS 0.1
import QtTest 1.0

Rectangle {
    id: window
    height: 640
    width: 480
    visible: true

    z: 100

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

        initialView: Item {
                property var navigationItem : NavigationItem {
                    title : "Quick iOS Example"
                }

                property string title : "Title"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        overlayView.open();
                    }
                }

                Text {
                    text: qsTr("Press for overlay")
                    anchors.centerIn: parent
                }
            }
    }

    OverlayView {
        id: overlayView
        width: parent.width
        height:parent.height


        NavigationBar {
            id: overlayNavBar
            views: overlayNavigation.views
            onLeftClicked: navigation.pop(true);
            titleAttributes: NavigationBarTitleAttributes {
                textColor : "#ff0000"
            }
        }

        NavigationView {
            id: overlayNavigation
            anchors.top: overlayNavBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            initialView: Item {
                property var navigationItem : NavigationItem {
                    title : "Overlay View"
                }
            }
        }
    }

    TestCase {
        name: "OverlayViewTests"
        when : windowShown

        function test_basic() {
            compare(overlayView.y , window.height);
            overlayView.open();
            wait(500);
            compare(overlayView.y , window.height - overlayView.height);
        }

        function test_demo() {
            // Just demo the look and feel.
            // It don't do any checking yet
            wait(60000);
//            wait(1000);
        }
    }


}
