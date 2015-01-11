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

    property alias navigationBar : navBar

    /* The first view that should be shown when the NavigationView is created.
       It should be an object. Component and string source is not allowed. It is
       just a convenience for writing Component.onCompleted: push()

       Moreover, don't change the value after created or your have pushed any view already.
     */
    property alias initialViewController : stack.initialViewController

    property alias views : stack.views

    // Create ViewController from source file or Component then push it into the stack.
    function push(source,options) {
        // Just like the present() and presentViewController() in ViewController. QuickIOS offer a solution
        // that will create the component for you. Those functions will not has suffix of "viewController"
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
        tintColor : navigationView.tintColor

        onPushed: {
            // Attach navigationView to a newly created view
            if (view.hasOwnProperty("navigationController"))
                view.navigationController = navigationView;
        }
    }

}
