/*
 NavigationView provides views management like UINavigationController in iOS

 Author: Ben Lau (benlau)

 */

import QtQuick 2.2
import "./priv"

Item {
    id : navigationView

    // The tint color to apply to the navigation bar background. It is equivalent to color. It apply the naming convenient of UIKit
    property string tintColor : "#007aff"

    property alias navigationBar : navBar

    property alias initialView : stack.initialView

    function push(source) {
        stack.push(source);
    }

    function pop() {
        stack.pop();
    }

    NavigationBar {
        id : navBar
        views: stack.views
        tintColor: navigationView.tintColor
        onLeftClicked: stack.pop(true);
    }

    NavigationStack {
        id : stack
        anchors.top: navBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        onPushed: {
            // Attach navigationView to a newly created view
            if (view.hasOwnProperty("navigationView"))
                view.navigationView = navigationView;
        }
    }

}
