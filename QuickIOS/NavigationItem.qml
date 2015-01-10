// NavigationItem object manages the buttons and views to be displayed in a NavigationBar object.
// Each view pushed into the NavigationController object may contains a NavigationItem object
// with buttons and views wants displayed in the navigation bar

// The NavigationItem simulates the behavior like the UINavigationItem in UIKit.

// Author: Ben Lau (benlau)

import QtQuick 2.0

Item {
    property bool backButtonVisible : true

    // The content that should be placed at the right of navigation bar
    property var rightBar

    // The content that should be placed at the left of navigation bar
    property var leftBar

    // Same as leftBar
    property var leftBarButtonItem

    property var leftBarButtonItems : VisualItemModel {}

    // Same as rightBar
    property var rightBarButtonItem

    property var rightBarButtonItems : VisualItemModel {}

}
