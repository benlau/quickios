import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import "appdelegate.js" as AppDelegate
import "./def"
import "./priv"
import "./utils/objectutils.js" as ObjectUtils

Rectangle {
  id: viewController

  property string title : ""

  default property alias content : viewport.data

  property var navigationController
  // It can't set type to NavigationController. It will create cyclic dependenices.

  property NavigationItem navigationItem : NavigationItem {}

  property color tintColor : parent && parent.tintColor ? parent.tintColor : Constant.tintColor

  /// The current toolBar instance
  property alias toolBarItem: toolBar

  /// The assigned item will be placed within the tool bar
  property alias toolBarItems : toolBar.content

  property alias backgroundColor : viewController.color

  signal viewWillAppear(bool animated)
  signal viewDidAppear(bool animated)
  signal viewWillDisappear(bool animated)
  signal viewDidDisappear(bool animated)

  color: Constant.viewControllerBackgroundColor
  objectName: "ViewController"

  signal pageChanged(var dstItem)

  // The transition component for presentViewController and dismissViewController
  property var _modelTransition;

  // present is a wrapper of presentViewController that accept multiple data type include string , Component etc.
  function present(source,options,animated) {
      var view = ObjectUtils.createObject(source,viewController,options);
      if (view)
          presentViewController(view,animated);
      return view;
  }

  function presentViewController(view,animated) {
      var root = viewController.parent;
      if (navigationController)
          root = navigationController;

      if (animated === undefined)
          animated = true;

      // Only a kind of transition is supported now.
      var transition = ObjectUtils.createObject(Qt.resolvedUrl("./transitions/CoverVerticalTransition.qml") ,
                                                view, { container : root , newView : view , originalView : viewController });
      view._modelTransition = transition;

      var controller = viewTransitionController.createObject(view, { view: view,
                                                                    container : root,
                                                                    transition : transition});

      view.parent = root;

      controller.present(animated);
      viewController.enabled = false;
      return view;
  }

  function dismissViewController(animated) {
      if (animated === undefined)
          animated = true;

      if (animated) {
          viewController._modelTransition.dismissTransition.start();
      } else {
          viewWillDisappear(false);
          _modelTransition.dismissTransitionFinished();
          viewDidDisappear(false);
      }
  }


  ColumnLayout {
      anchors.fill: parent
      spacing : 0

      Item {
          id: viewport
          property color tintColor : viewController.tintColor
          Layout.fillHeight: true
          Layout.fillWidth: true
      }

      ToolBar {
          id: toolBar
          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.maximumHeight: height
          Layout.minimumHeight: height
          height: toolBar.content.length > 0 ? 44 :0

          onContentChanged: {
              if (content.length <= 0)
                  return;
              var child = content[0];
              child.anchors.fill = child.parent;
          }
      }
  }

  onParentChanged: {
      if (this.parent === undefined)
          return;
      var p = parent;
      while (p) {
          if (p.hasOwnProperty("navigationController")) {
              navigationController = Qt.binding(function() {
                  return p.navigationController;
              });
              break;
          }
          p = p.parent;
      }
  }

  Component { // Create a container for the view added by presentViewController
      id: viewTransitionController
      Item {
          id: transitionController
          x: 0
          y: 0
          width: parent.width
          height: parent.height
          property var container;
          property var view;
          property var transition;
          property string tintColor : viewController.tintColor

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

                  viewController.enabled = true;
                  view.viewDidDisappear(true);

                  transitionController.destroy();
              }
          }

          onViewChanged: {
              if (view) {
                  view.width = Qt.binding(function() {return container.width });
                  view.height = Qt.binding(function() {return container.height });
              }
          }
      }
  }

}
