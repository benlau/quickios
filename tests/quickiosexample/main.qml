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
                    ListElement { title : "Alert View" ; file : "alertview/AlertViewDemo.qml" }
                    ListElement { title : "Action Sheet" }
                    ListElement { title : "Image Picker" ; file :"imagePicker/ImagePickerDemo.qml" }
                    ListElement { title : "Tool Bar"; file : "toolBar/ToolBarDemo.qml" }
                    ListElement { title : "Activity Indicator" }
                }

                onSelected: {
                    switch (index) {
                    case 1:
                        actionSheet.show();
                        break;
                    case 4:
                        activityIndicator.startAnimation();
                        activityIndicatorTimer.start();
                        break;
                    default:
                        var item = model.get(index);
                        navigationController.push(Qt.resolvedUrl(item.file));
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
        otherButtonTitles : ["Button 1","Button2"]
        cancelButtonTitle : "Cancel"
        onClickedButtonIndexChanged: {
            console.log("Clicked Button")
        }
    }

    ActionSheet {
        id : pickerAction
        title : "Pick Photo"
        otherButtonTitles : ["Photo Library","Camera","Saved Album"];
        onClicked: {
            picker.sourceType = index;
            picker.show();
        }
    }

    ActivityIndicator {
        id : activityIndicator

        Timer {
            id : activityIndicatorTimer;
            interval : 3000
            onTriggered: activityIndicator.stopAnimation();
        }
    }

    ImagePicker {
        id : picker
    }

    Component.onCompleted: {
        navigation.push(rootView,false);
    }

}
