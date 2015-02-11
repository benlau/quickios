import QtQuick 2.0
import QuickIOS 0.1

Item {
    id : listener

    /// The target to be listened.
    property ViewController viewController

    property int didDisappearCount : 0

    property int willDisappearCount : 0

    property int willAppearCount : 0

    property int didAppearCount : 0

    function reset() {
        didDisappearCount = willDisappearCount = willAppearCount = didAppearCount = 0;
    }

    Connections {
        target: viewController


        onViewWillAppear: willAppearCount++;
        onViewDidAppear: didAppearCount++;
        onViewWillDisappear: willDisappearCount++;
        onViewDidDisappear:  didDisappearCount++
    }
}

