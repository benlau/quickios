/*
Author: Ben Lau (benlau)
License: Apache License
Project: https://github.com/hilarycheng/quickios
*/
import QtQuick 2.0
import "../priv"

QtObject {

    /// The container provide the geometry information
    property Item container : null;

    /// The view going to be presented or dismissed.
    property Item newView : Item {}

    /// The original view.
    property Item originalView : Item {}

    readonly property int duration : 300;

    signal aboutToDismiss
    signal dismissed
    signal aboutToPresent
    signal presented

    property int _height : newView ? newView.height : 0

    function presentTransitionFinished() {
        newView.x = Qt.binding(function() { return container ? container.x  : 0});
        newView.y = Qt.binding(function() { return container ? container.y : 0});
        newView.width = Qt.binding(function() { return container ? container.width : 0 });
        newView.height = Qt.binding(function() { return container ? container.height : 0});
        originalView.enabled = false;
        newView.enabled = true;
    }

    function dismissTransitionFinished() {
        newView.visible = false;
        newView.enabled = false;
        originalView.enabled = true;
    }

    property var presentTransition: ParallelAnimation {

        PropertyAnimation {
            target: newView
            property: "y"
            from: _height
            to: 0
            duration: duration
            easing.type: Easing.Linear
            alwaysRunToEnd : true
        }

        onStarted: aboutToPresent();

        onStopped: {
            presented();
        }
    }

    property var dismissTransition: ParallelAnimation {
        PropertyAnimation {
            target: newView
            property: "y"
            from: 0
            to: _height
            duration: duration
            easing.type: Easing.Linear
        }

        onStarted: aboutToDismiss();

        onStopped: {
            dismissed();
        }
    }

}

