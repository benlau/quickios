import QtQuick 2.0
import QtQuick.Controls 1.2

StackViewDelegate {
    id: root

    readonly property int fastDuration : 300
    readonly property int slowDuration : 500

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
       }
       PropertyAnimation {
           target: exitItem
           property: "x"
           from: 0
           to: -target.width
           duration: root.slowDuration
       }

       PropertyAnimation {
           target: exitItem.titleView
           property : "opacity"
           from : 1
           to : 0
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
           target: enterItem.titleView
           property : "opacity"
           from : 0
           to : 1
           duration: root.slowDuration
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
