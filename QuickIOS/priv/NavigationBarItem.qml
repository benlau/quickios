// NavigationBarItem is a children of NavigationBar to display the navigation controls
// for the top view.
import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1

Rectangle {
  id: navigationBarItem

  // TRUE if the back button should be visible
  property bool backStage: false

  property alias barTintColor : navigationBarItem.color

  property alias title: navigationTitle.text
  property alias titleView : navigationTitle

  property VisualItemModel leftBarButtonItems : VisualItemModel {}

  property VisualItemModel rightBarButtonItems : VisualItemModel {}

  signal leftClicked()
  signal rightClicked()

  color: "#f8f8f8"

  Text {
    id: navigationTitle
    font.family: "Helvetica Neue"
    renderType: Text.NativeRendering
    text: ""
    font.weight: Font.Bold
    width: parent.width
    height: parent.height - 1
    wrapMode: Text.NoWrap
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    color: "#000000"
    font.pixelSize: 17
  }

  Item {
      // The area reserved for right bar.
      id : leftBarArea
      anchors.left: parent.left
      anchors.leftMargin: backStage ? 22 + 12 : 12
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      Row {
          spacing : 8
          anchors.verticalCenter: parent.verticalCenter
          Repeater {
              model : leftBarButtonItems
          }
      }
  }

  Item {
      // The area reserved for right bar.
      id : rightBarArea
      x: parent.width - rightBarRepeater.width - 12
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      Row {
          id: rightBarRepeater
          spacing : 8
          anchors.verticalCenter: parent.verticalCenter
          Repeater {
              model : rightBarButtonItems
          }
      }
  }

  Rectangle {
    x: 0
    y: parent.height - 1
    width: parent.width
    height: 1
    color: "#acacac"
  }

}
