import QtQuick 2.0

Item {
    id: behaviour

    property Item grand : null;

    function update() {
        if (parent &&
            parent.parent &&
            parent.parent.hasOwnProperty("tintColor")) {
            grand = parent.parent;
            parent.tintColor = grand.tintColor;
        } else {
            grand = null;
        }
    }

    Connections {
        target: behaviour.parent
        ignoreUnknownSignals: true
        onParentChanged: {
            if (behaviour)
                behaviour.update();
        }
    }

    Connections {
        target: grand;
        ignoreUnknownSignals: true

        onTintColorChanged: {
            if (parent)
                parent.tintColor = grand.tintColor;
        }
    }

    Component.onCompleted: {
        behaviour.update();
    }

}

