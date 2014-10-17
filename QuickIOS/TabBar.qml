import QtQuick 2.2
import QtQuick.Window 2.1

Rectangle {
  id: tabBar

  property int tabsHeight: 48
  property int tabIndex: 0

  property VisualItemModel tabsModel

  width: parent.width
  height: 49

  color: "#f8f8f8"

  anchors.bottom: parent.bottom
  anchors.bottomMargin: 0
  anchors.right: parent.right
  anchors.rightMargin: 0
  anchors.left: parent.left
  anchors.leftMargin: 0

  Rectangle {
    x: 0
    y: 0
    width: parent.width
    height: 1
    color: "#acacac"
  }

  Rectangle {
    id: tabContainer

    x: 0
    y: 1
    width: parent.width
    height: parent.height - 1

    Repeater {
      model: tabsModel
    }
  }

  Component {
    id: tabBarItem

    Rectangle {
      height: tabsHeight
      width: tabs.width / tabsModel.count
      color: "transparent"

      Image {
        source: tabsModel.children[index].icon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
      }

      Text {
        font.pixelSize: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        color: "black"
        text: tabsModel.children[index].name
      }
    }
  }

  Rectangle {
    id: tabBarRect
    width: parent.width
    height: parent.height - 1
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    Row {
      anchors.fill: parent
      id: tabs
      Repeater {
        model: tabsModel.count
        delegate: tabBarItem
      }
    }
  }


}
