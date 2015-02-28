// It is a coordinator for handing the transition triggered by presentViewController()
import QtQuick 2.0

Item {
    id: coordinator
    x: 0
    y: 0
    width: parent.width
    height: parent.height

    property var container;

    // The previous view.
    property var origView

    // The view that is going to present
    property var view;
    property var transition;

    signal dismissed();

    function present(animated) {
        if (animated) {
            view._modelTransition.presentTransition.start();
        } else {
            view.viewWillAppear(false);
            transition.presentTransitionFinished();
            view.viewDidAppear(false);
        }
    }

    function dismiss() {
        view._modelTransition.dismissTransition.start();
    }

    function setStatusBarHidden(view) {
        var hidden = view.prefersStatusBarHidden;
        var animation = view.preferredStatusBarUpdateAnimation;
        QISystem.sendMessage("applicationSetStatusBarHidden", {
                                 hidden: hidden,
                                 animation : animation
                             });
    }

    Item {
        // Provide tintColor to view but it don't let enabled change propagate to the newView
        id : bridge
        property color tintColor: origView.tintColor
    }

    Connections {
        target: transition

        onAboutToPresent: {
            view.viewWillAppear(true);
        }

        onPresented: {
            transition.presentTransitionFinished();

            view.viewDidAppear(true);
        }

        onAboutToDismiss: {
            view.viewWillDisappear(true);
        }

        onDismissed: {
            transition.dismissTransitionFinished();

            view.viewDidDisappear(true);

            coordinator.destroy();
        }
    }

    Connections {
        target: view
        ignoreUnknownSignals: true
        onViewWillAppear: {
            view.setNeedsStatusBarAppearanceUpdate();
        }

        onViewWillDisappear: {
            origView.setNeedsStatusBarAppearanceUpdate();
            coordinator.dismissed();
        }
    }

    onViewChanged: {
        if (view) {
            view.parent = bridge;
            view.width = Qt.binding(function() {return container.width });
            view.height = Qt.binding(function() {return container.height });
        }
    }
}

