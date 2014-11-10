// NavigationView provides views management like UINavigationController in iOS
// Author: Ben Lau (benlau)

import QtQuick 2.0
import QtQuick.Controls 1.2
import "./priv"

Item {
    id: navigationView
    width: 100
    height: 62

    // The title of current view
    property string title : ""
    property var views : new Array

    function push(source) {
        var view;
        if (typeof source === "string") {
            var comp = Qt.createComponent(source);
            view = comp.createObject(navigationView);
        } else {
            view = source;
        }
        stack.push(view);
        views.push(view);
        viewsChanged();
    }

    function pop() {
        if (stack.depth == 1)
            return;
        stack.pop();
        views.splice(views.count - 1,1);
    }

    StackView {
        id : stack
        anchors.fill: parent
        delegate: NavigationViewDelegate {}
    }

    /*
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

            Binding { target: entryAnim.item;property: "running";
                      when: item.alive && model.animated; value: true;}
            Binding { target: entryAnim.item;property: "target";when: true; value: item;}

            Binding { target: exitAnim.item;property: "running";when: !item.alive; value: true;}
            Binding { target: exitAnim.item;property: "target";when: true; value: item;}

            Connections {
                target: exitAnim.item
                onStopped: {
                    stack.remove(stack.count -1);
                }
            }

            Connections {
                target: content
                onLoaded: {
                    views.push(content.item);
                    viewsChanged();
                }
            }
            Component.onDestruction: {
                views.splice(views.count - 1,1);
                viewsChanged();
            }
        }
    }
*/
    Binding {
        target: navigationView
        property : "title"
        value : views[views.length - 1].title
        when: views.length > 0
    }
}
