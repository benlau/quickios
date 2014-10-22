import QtQuick 2.2
import QtQuick.Window 2.1

Text {
  id: ibutton
  font.family: "Helvetica Neue"
  font.pixelSize: 14
  color: "#007aff"
  anchors.horizontalCenter: parent.horizontalCenter

  signal clicked()

  MouseArea {
    anchors.fill: parent

    onPressed: {
      parent.color = "#cce4ff"
    }
    onReleased: {
      parent.color = "#007aff"
    }
    onClicked: {
      ibutton.clicked()
    }
  }
}
