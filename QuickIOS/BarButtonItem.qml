import QtQuick 2.0
import QtQuick.Controls 1.2

MouseArea {
    id : barButtonItem

    property alias title : textItem.text
    property alias image : imageItem.source

    width: textItem.contentWidth + 16
    height: textItem.contentHeight

    Text {
      id: textItem
      font.family: "Helvetica Neue"
      renderType: Text.NativeRendering
      font.pixelSize: 16
      color: "#007aff"
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }

    Image {
        id : imageItem
    }

    Binding {
        target: barButtonItem
        property: "width"
        value: imageItem.width
        when: imageItem.status === Image.Ready
    }

    Binding {
        target: barButtonItem
        property: "height"
        value: imageItem.height
        when: imageItem.status === Image.Ready
    }
}
