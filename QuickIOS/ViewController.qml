import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import "appdelegate.js" as AppDelegate
import "./def"
import "util.js" as Util
import "./priv"

Rectangle {
  id: viewController

  property string title : ""

  default property alias content : viewport.data

  property var navigationController
  // It can't set type to NavigationController. It will create cyclic dependenices.

  property NavigationItem navigationItem : NavigationItem {}

  property color tintColor : parent && parent.tintColor ? parent.tintColor : Constant.tintColor

  property alias toolBar: toolBar
  property alias toolBarItems : toolBar.content

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

      view.parent = container;

      container.present();
      viewController.enabled = false;
  }

  function dismissViewController(animated) {
      viewController._modelTransition.dismissTransition.start();
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

              onAboutToPresent: {
                  view.viewWillAppear(true);
              }

              onPresented: {
                  view.viewDidAppear(true);
              }

              onAboutToDismiss: {
                  view.viewWillDisappear(true);
              }

              onDismissed: {
                  viewController.enabled = true;
                  view.viewDidDisappear(true);
                  container.destroy();                  
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
