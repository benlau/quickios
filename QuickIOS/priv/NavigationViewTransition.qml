import QtQuick 2.0
import QtQuick.Controls 1.2

StackViewDelegate {
    id: root

    readonly property int fastDuration : 300
    readonly property int slowDuration : 600

    function transitionFinished(properties)
    {
        properties.exitItem.x = 0
        properties.exitItem.y = 0
    }

    pushTransition: StackViewTransition {
       PropertyAnimation {
           target: enterItem
           property: "x"
           from: target.width
           to: 0
           duration: root.fastDuration
           easing.type: Easing.OutQuad
       }
       PropertyAnimation {
           target: exitItem
           property: "x"
           from: 0
           to: -target.width
           duration: root.slowDuration
       }
    }

    popTransition: StackViewTransition {
       PropertyAnimation {
           target: enterItem
           property: "x"
           from: -target.width
           to: 0
           duration: root.fastDuration
       }
       PropertyAnimation {
           target: exitItem
           property: "x"
           from: 0
           to: target.width
           duration: root.fastDuration
       }
   }

    replaceTransition: pushTransition
}
