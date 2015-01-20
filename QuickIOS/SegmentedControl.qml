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

    default property alias __children : tabView.children
//    property ObjectModel items : ObjectModel {}
    property color tintColor : "#007aff"
    property alias count : tabView.count
    property alias currentIndex : tabView.currentIndex
    property alias numberOfSegments : tabView.count

    TabView {
        id: tabView
        anchors.fill: parent
        style: SegmentedControlTabViewStyle {
            tintColor : segmentedControl.tintColor
        }

//        Repeater {
//            model : items
//        }
    }

    InheritTintColor {}

}
