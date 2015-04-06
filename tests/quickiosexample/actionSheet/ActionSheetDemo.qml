import QtQuick 2.0
import QuickIOS 0.1
import QtQuick.Controls 1.2

ViewController {
    width: 100
    height: 62
    color : "#ffffff"
    title : "Alert Sheet Demo"

    property var navigationItem : NavigationItem {
        rightBarButtonItems : VisualItemModel {
            BarButtonItem {
                title: "Show"
                onClicked: {
                    actionSheet.show();
                }

                ActionSheet {
                    // Action Sheet behavior differently in iPad. It will become a popover component.
                    // Therefore it need the information of where did it be triggered
                    id: actionSheet
                    anchors.fill: parent
                    title : "Action Sheet Demo"
                    otherButtonTitles : ["Button 1","Button2"]
                    cancelButtonTitle : "Cancel"
                    onClickedButtonIndexChanged: {
                        console.log("Clicked Button",clickedButtonIndex);
                    }
                }
            }

        }
    }

}
