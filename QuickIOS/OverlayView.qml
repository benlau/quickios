import QtQuick 2.0

Rectangle {
    id: view
    property bool active: false

    function open() {
        active = true;
    }

    function close() {
        active = false;
    }

    Behavior on y {
        NumberAnimation {
            duration : 300
            easing.type: Easing.Linear
        }
    }

    width: 100
    height: 62

    Binding {
        target: view
        property: "y"
        value: view.parent.height
        when: !active
    }

    Binding {
        target: view
        property: "y"
        value: view.parent.height - view.height
        when: active
    }
}
