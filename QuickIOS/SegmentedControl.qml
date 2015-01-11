/* SegmentedControl implements the UISegmentedControl in QML way.

  The limitation:

  1. It don't support to modify the detailed style yet.
     Only tintColor is supported

  2. It can't use image as the tab icon.

 */
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQml.Models 2.1
import QtQuick.Controls 1.2 as QuickControl
import "./priv"

Item {
    id: segmentedControl

    property ObjectModel items : ObjectModel {}
    property color tintColor : "#007aff"
    property alias count : tabView.count
    property alias currentIndex : tabView.currentIndex

    TabView {
        id: tabView
        anchors.fill: parent
        style: SegmentedControlTabViewStyle {
            tintColor : segmentedControl.tintColor
        }

        Repeater {
            model : items
        }
    }

    onParentChanged: {
        if (parent && parent.hasOwnProperty("tintColor")) {
            tintColor = parent.tintColor;
        }
    }

}
