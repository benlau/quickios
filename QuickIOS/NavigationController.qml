/*
 NavigationController provides views management like UINavigationController in iOS

  Author: Ben Lau (benlau)
  License: Apache License
  Project: https://github.com/hilarycheng/quickios

 */

import QtQuick 2.2
import "./priv"

ViewController {
    id : navigationView

    // The tint color to apply to the navigation bar background. It is equivalent to color. It apply the naming convenient of UIKit
    property string tintColor : "#007aff"

    property alias navigationBar : navBar

    /* The first view that should be shown when the NavigationView is created.
       It should be an object. Component and string source is not allowed. It is
       just a convenience for writing Component.onCompleted: push()

       Moreover, don't change the value after created or your have pushed any view already.
     */
    property alias initialView : stack.initialView

    property alias views : stack.views

    function push(source,options) {
        stack.push(source,options);
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
            if (view.hasOwnProperty("navigationController"))
                view.navigationController = navigationView;
        }
    }

}
