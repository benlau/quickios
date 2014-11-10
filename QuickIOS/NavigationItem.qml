// NavigationItem object manages the buttons and views to be displayed in a NavigationBar object.
// Each view pushed into the NavigationView object may contains a NavigationItem object
// with buttons and views wants displayed in the navigation bar

// The NavigationItem simulates the behavior like the UINavigationItem in UIKit.

// Author: Ben Lau (benlau)

import QtQuick 2.0

Item {
    property string title : ""

    property bool backButtonVisible : true
}
