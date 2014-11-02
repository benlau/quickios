// NavigationView provides views management like UINavigationController in iOS
// Author: Ben Lau (benlau)

import QtQuick 2.0

Item {
    id: navigationView
    width: 100
    height: 62

//    property alias views : stack

    function push(content) {
        var data = {
            source : "",
            instance : {
            }
        };

        if (typeof content === "string") {
            data.source = content;
        } else {
            data.instance = {
                sourceComponent : content
            }
        }
        stack.append(data);
    }

    function pop() {
//        if (stack.count > 0) // Non animated removal
//            stack.remove(stack.count - 1);
        if (repeater.count > 0) // Animated remove
            repeater.itemAt(repeater.count - 1).alive = false;
    }

    ListModel {
        id : stack
    }

    Repeater {
        anchors.fill: parent
        id : repeater
        model: stack
        z: 100000

        delegate: Item {
            id: item
            enabled: index === stack.count - 1 ; // Only the top page is enabled
            x: 0; // Don't use anchors for animation
            y: 0;
            width: repeater.width;
            height: repeater.height;

            property bool alive : true

            Loader {
                id: entryAnim
                source: Qt.resolvedUrl("anims/MoveInFromRight.qml");
            }

            Loader {
                id: exitAnim
                source: Qt.resolvedUrl("anims/MoveOutToRight.qml");
            }

            Loader {
                id: content
                active: true
                source: model.source
                sourceComponent: model.instance.sourceComponent
                anchors.fill: parent
            }

            Binding { target: entryAnim.item;property: "running";when: item.alive; value: true;}
            Binding { target: entryAnim.item;property: "target";when: true; value: item;}

            Binding { target: exitAnim.item;property: "running";when: !item.alive; value: true;}
            Binding { target: exitAnim.item;property: "target";when: true; value: item;}

            Connections {
                target: exitAnim.item
                onStopped: {
                    stack.remove(stack.count -1);
                }
            }
        }
    }

}
