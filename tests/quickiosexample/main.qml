import QtQuick 2.3
import QtQuick.Window 2.2
import QuickIOS 0.1

Window {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true

    Component {
        id: rootView
        ViewController {
            title : "Quick iOS Example Program"

            navigationItem : NavigationItem {
            }

            TableSection {
                y: 10
                width: parent.width

                headerTitle: "System Components"
                model: ListModel {
                    ListElement { title : "Alert View" }
                    ListElement { title : "Action Sheet" }

                }

                onSelected: {
                    switch (index) {
                    case 0:
                        navigationController.push(Qt.resolvedUrl("alertview/AlertViewDemo.qml"));
                        break;
                    case 1:
                        actionSheet.show();
                        break;
                    }
                }
            }
        }
    }

    NavigationController {
        id : navigation
        navigationBar.titleAttributes: NavigationBarTitleAttributes {
            textColor : "#ff0000"
        }
        anchors.fill: parent
    }

    ActionSheet {
        id: actionSheet
        title : "Action Sheet Demo"
        otherButtonTitles : ["Button 1","Button 2"]
        cancelButtonTitle : "Cancel"
        onClickedButtonChanged: {
            console.log("clicked button",clickedButtonIndex)
        }
    }

    Component.onCompleted: {
        navigation.push(rootView,false);
    }

}
