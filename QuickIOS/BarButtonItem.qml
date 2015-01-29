import QtQuick 2.0
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0
import "./def"

MouseArea {
    id : barButtonItem

    property alias title : textItem.text
    property alias image : imageItem.source
    property alias imageSourceSize : imageItem.sourceSize

    property color tintColor : parent && parent.tintColor ? parent.tintColor : Constant.tintColor

    opacity: pressed ? 0.2 : 1

    width: textItem.contentWidth + 16
    height: textItem.contentHeight

    Text {
      id: textItem
      anchors.centerIn: parent
      font.family: "Helvetica Neue"
      renderType: Text.NativeRendering
      font.pixelSize: 16
      color: barButtonItem.tintColor
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }

    Image {
        id : imageItem
        anchors.centerIn: parent
    }

    ColorOverlay {
        id : overlay
        source: imageItem
        anchors.fill: imageItem
        color: tintColor
        visible: image !== undefined
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
