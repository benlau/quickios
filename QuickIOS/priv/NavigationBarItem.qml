// NavigationBarItem is a children of NavigationBar to display the navigation controls
// for the top view.
import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1

Rectangle {
  id: navigationBarItem

  property bool backStage: false

  property alias barTintColor : navigationBarItem.color

  property alias title: navigationTitle.text
  property alias titleView : navigationTitle

  property alias leftBar: leftBarArea
  property alias rightBar: rightBarArea

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

  /*
  Text {
    id: leftTextButton
    anchors.left: parent.left
    anchors.leftMargin: backStage ? 22 : 0
    anchors.top: parent.top
    anchors.topMargin: 1
    anchors.bottom: parent.bottom
    width: parent.height
    height: parent.height
    text: ""
    font.family: "Helvetica Neue"
    renderType: Text.NativeRendering
    font.pixelSize: 16
    color: "#007aff"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    MouseArea {
      anchors.fill: parent
      onClicked: {
        navigationBarItem.leftClicked();
      }
    }
  }

  Image {
    id: leftIconButton
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: parent.height
    height: parent.height
    MouseArea {
      anchors.fill: parent
      onClicked: {
        navigationBarItem.leftClicked();
      }
    }
  }
  */

  Item {
      // The area reserved for right bar.
      id : leftBarArea
      width: childrenRect.width
      anchors.left: parent.left
      anchors.leftMargin: backStage ? 22 + 8 : 0
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      Row {
          spacing : 8
          anchors.centerIn: parent
          Repeater {
              model : leftBarButtonItems
          }
      }
  }

  Item {
      // The area reserved for right bar.
      id : rightBarArea
      width: childrenRect.width
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      Row {
          spacing : 8
          anchors.centerIn: parent
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
