import QtQuick 2.2
import QtQuick.Window 2.1

Rectangle {
  id: navigationBar

  property bool backStage: false
  property alias title: navigationTitle.text
  property alias rightIcon: rightIconButton.source
  property alias rightText: rightTextButton.text
  property alias leftIcon: leftIconButton.source
  property alias leftText: leftTextButton.text


  width: parent.width
  height: 44

  color: "#f8f8f8"

  anchors.top: parent.top
  anchors.topMargin: 0
  anchors.right: parent.right
  anchors.rightMargin: 0
  anchors.left: parent.left
  anchors.leftMargin: 0

  Text {
    id: navigationTitle
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
    font.pixelSize: 16
    color: "#007aff"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }

  Image {
    id: backButton
    anchors.left: parent.left
    anchors.leftMargin: 8
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    visible: backStage
    width: 13
    height: 21
    source: "qrc:///QuickIOS/images/back.png"
    fillMode: Image.PreserveAspectFit
  }

  Image {
    id: leftIconButton
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: parent.height
    height: parent.height
  }

  Text {
    id: rightTextButton
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 1
    anchors.bottom: parent.bottom
    width: parent.height
    height: parent.height
    text: ""
    font.pixelSize: 16
    color: "#007aff"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }

  Image {
    id: rightIconButton
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: parent.height
    height: parent.height
  }

  Rectangle {
    x: 0
    y: parent.height - 1
    width: parent.width
    height: 1
    color: "#acacac"
  }

}
