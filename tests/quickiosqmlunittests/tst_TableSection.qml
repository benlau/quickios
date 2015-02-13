import QtQuick 2.0
import QtQuick.Controls 1.2
import QtTest 1.0
import QuickIOS 0.1


ViewController {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true
    tintColor : "#000000"

    ScrollView {
        anchors.fill: parent

        flickableItem.interactive : true;

        Column {
            id : column
            width: window.width

            TableSection {
                // It is part of UITableView in grouped style

                id : section1
                width: parent.width

                headerTitle : "Start of Session"
                model : ListModel {
                    ListElement { title: "A" ; value: 1}
                    ListElement { title: "B" ; value: 2}
                    ListElement { title: "C" ; value: 3}
                }

                footerTitle : "End of Session"
                separatorColor: "#1F000000"
                separatorInsetLeft: 5
                separatorInsetRight: 5
                rowHeight: 44
            }

            TableSection {
                // It is part of UITableView in grouped style
                width: parent.width

                model : ListModel {
                    ListElement { title: "A" ; value: 1}
                    ListElement { title: "B" ; value: 2}
                    ListElement { title: "C" ; value: 3}
                }

                separatorColor: "#1F000000"
                separatorInsetLeft: 5
                separatorInsetRight: 5
                rowHeight: 44
            }

        }

    }

    TestCase {
        name: "TableSection"
        when : windowShown

        function test_preview() {
            wait(TestEnv.waitTime);
        }
    }


}
