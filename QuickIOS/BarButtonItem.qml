import QtQuick 2.0
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0
import "./def"

MouseArea {
    id : barButtonItem

    property alias title : textItem.text
    property alias image : imageItem.source
    property alias imageSourceSize : imageItem.sourceSize

    property alias fontSize : textItem.font.pixelSize

    property color tintColor : parent && parent.tintColor ? parent.tintColor : Constant.tintColor

    width: Math.max(textItem.contentWidth,imageItem.width)  + 16
    height: textItem.contentHeight * (title !== "" ) + imageItem.height

    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id : imageItem
            anchors.horizontalCenter: parent.horizontalCenter

            ColorOverlay {
                id : overlay
                source: imageItem
                anchors.fill: imageItem
                color: tintColor
                visible: image !== undefined
            }

        }

        Text {
          id: textItem
          anchors.horizontalCenter: parent.horizontalCenter
          font.family: "Helvetica Neue"
          renderType: Text.NativeRendering
          font.pixelSize: 16
          color: barButtonItem.tintColor
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }

    }

    states: [
        State {
            when: pressed

            PropertyChanges {
                target: barButtonItem
                opacity : 0.2

            }
        }
    ]

}
