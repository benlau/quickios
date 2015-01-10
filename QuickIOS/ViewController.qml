import QtQuick 2.2
import QtQuick.Window 2.1
import "appdelegate.js" as AppDelegate
import "util.js" as Util

Rectangle {

  property var navigationView;
  property var navigationController : navigationView

  property NavigationItem navigationItem : NavigationItem {}

  signal viewWillAppear(bool animated)
  signal viewDidAppear(bool animated)
  signal viewWillDisappear(bool animated)
  signal viewDidDisappear(bool animated)

  id: viewController
  color: "#ffffff"
  objectName: "ViewController"


  signal pageChanged(var dstItem)

  // The transition component for presentViewController and dismissViewController
  property var _modelTransition;

  function presentViewController(view,animated) {
      var root = viewController;
      if (navigationController)
          root = navigationController;

      // Only a kind of transition is supported now.
      var transition = Util.createObject("./transitions/CoverVerticalTransition.qml");
      view._modelTransition = transition;
      view._modelTransition.view = view;

      var container = viewContainer.createObject(root, { view: view,transition : transition});
      view.width = Qt.binding(function() {return container.width });
      view.height = Qt.binding(function() {return container.height });

      view.parent = container;

      container.present();
  }

  function dismissViewController(animated) {
      viewController._modelTransition.dismissTransition.start();
  }

  Component {
      id: viewContainer
      Item {
          x: 0
          y: 0
          width: parent.width
          height: parent.height
          property var view;
          property var transition;

          function present() {
              view._modelTransition.presentTransition.start();
          }

          function dismiss() {
              view._modelTransition.dismissTransition.start();
          }

          Connections {
              target: transition
              onDismissed: {
                  viewContainer.destroy();
              }
          }
      }
  }

}
