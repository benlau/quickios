/*
Author: Ben Lau (benlau)
License: Apache License
Project: https://github.com/hilarycheng/quickios
*/
import QtQuick 2.0
import "../priv"

QtObject {

    property Item view : Item {}
    readonly property int duration : 300;

    signal dismissed
    signal presented

    property int _height : view ? view.height : 0

    property ViewControllerTransition presentTransition: ViewControllerTransition {
        PropertyAnimation {
            target: view
            property: "y"
            from: _height
            to: 0
            duration: duration
            easing.type: Easing.Linear
        }

        onStopped: {
            presented();
        }
    }

    property ViewControllerTransition dismissTransition: ViewControllerTransition {
        PropertyAnimation {
            target: view
            property: "y"
            from: 0
            to: _height
            duration: duration
            easing.type: Easing.Linear
        }

        onStopped: {
            dismissed();
        }
    }

}

