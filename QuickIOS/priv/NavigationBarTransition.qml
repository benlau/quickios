import QtQuick 2.0
import QtQuick.Controls 1.2

StackViewDelegate {
    id: root

    readonly property int fastDuration : 400
    readonly property int slowDuration : 460

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
           duration: root.fastDuration
           easing.type: Easing.OutQuad

       }

       PropertyAnimation {
           target: exitItem.titleView
           property : "opacity"
           from : 1
           to : 0
           duration: root.fastDuration
           easing.type: Easing.OutQuad

       }
    }

    popTransition: StackViewTransition {
       PropertyAnimation {
           target: enterItem
           property: "x"
           from: -target.width
           to: 0
           duration: root.slowDuration
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
