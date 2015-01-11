import QtQuick 2.2
import QtQuick.Window 2.1
import "appdelegate.js" as AppDelegate
import "util.js" as Util

Rectangle {
  property string title : ""

  property var navigationController
  // It can't set type to NavigationController. It will create cyclic dependenices.

  property NavigationItem navigationItem : NavigationItem {}

  property string tintColor : "#007aff"

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

  // present is a wrapper of presentViewController that accept multiple data type include string , Component etc.
  function present(source,options,animated) {
      var view = Util.createObject(source,viewController,options);
      if (view)
          presentViewController(view,animated);
      return view;
  }

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

  Component { // Create a container for the view added by presentViewController
      id: viewContainer
      Item {
          id: container
          x: 0
          y: 0
          width: parent.width
          height: parent.height
          property var view;
          property var transition;
          property string tintColor : viewController.tintColor

          function present() {
              view._modelTransition.presentTransition.start();
          }

          function dismiss() {
              view._modelTransition.dismissTransition.start();
          }

          Connections {
              target: transition
              onDismissed: {
                  container.destroy();
              }
          }
      }
  }

  onParentChanged: {
      // @TODO Extract this function
      if (parent && parent.hasOwnProperty("tintColor")) {
          tintColor = Qt.binding(function() {
             return parent ? parent.tintColor : "#007aff";
          });
      }
  }

}
