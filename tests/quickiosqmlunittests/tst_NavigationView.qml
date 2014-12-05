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


    TestCase {
        name: "NavigationViewTests"
        when : windowShown

        function test_initialView() {
            compare(navigationView.navigationBar.views.count , 1);
            compare(rootView.navigationView , navigationView);
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
