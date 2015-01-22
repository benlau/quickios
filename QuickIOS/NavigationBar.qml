import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQml.Models 2.1
import QuickIOS 0.1
import "./priv"

Rectangle {
  id: navigationBar

  // The tint color to apply to the navigation bar background. It is equivalent to color. It apply the naming convenient of UIKit
  property string tintColor : "#007aff"

  property alias barTintColor : navigationBar.color

  // The view objects within NavigationView
  property ListModel views : ListModel{}

  // The top most navigation item
  property NavigationItem navigationItem : dummyNavigationItem

  property ListModel navigationItems : ListModel{}

  property NavigationBarTitleAttributes titleAttributes : NavigationBarTitleAttributes {}

  signal backClicked()

  // The current title
  property string currentTitle

  // The current list of left buttons
  property var currentLeftButtonItems : null

  // The current list of right buttons
  property var currentRightButtonItems : null

  width: parent.width
  height: QIDevice.screenFillStatusBar ? 44 + 20 : 44

  color : "#f8f8f8"

  anchors.top: parent.top
  anchors.topMargin: 0
  anchors.right: parent.right
  anchors.rightMargin: 0
  anchors.left: parent.left
  anchors.leftMargin: 0

  NavigationItem {
    id : dummyNavigationItem
  }

  ObjectModel {
      id : dummyItemModel;
  }

  StackView {
      id : stack
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height : 44
      delegate: NavigationBarTransition {}

      onDepthChanged: {
          var index = depth -1;
          if (index < 0) {
              currentTitle = "";
          } else {
              var controller = get(index);
              currentTitle = Qt.binding(function() {
                  return controller.title;
              });
          }
      }
  }

  Item {
      anchors.left: parent.left
      anchors.leftMargin: 8
      anchors.bottom: parent.bottom
      width: 22
      height: 44

      BarButtonItem {
          id: backButton
          anchors.fill: parent
          visible: views.count > 1
          image: "qrc:///QuickIOS/images/back.png"
          tintColor: navigationBar.tintColor
          onClicked: {
           navigationBar.backClicked();
          }
      }
  }


  Repeater {
      id: viewsListener
      model : navigationBar.views
      delegate: Item {
          id: item

          property var navigationItem : NavigationItem {}
          property string title;

          Component {
              id: creator
              NavigationBarItem {
                  title: item.title
                  backStage: index > 0
                  leftBarButtonItems: navigationItem.leftBarButtonItems
                  rightBarButtonItems: navigationItem.rightBarButtonItems
                  barTintColor : navigationBar.barTintColor
                  titleView.color: titleAttributes.textColor
              }
          }

          function setup(model) {
              for (var i = 0 ; i < model.children.length; i++) {
                  var child = model.children[i];
                  if (child.hasOwnProperty("tintColor")) {
                      child.tintColor = Qt.binding(function() {return navigationBar.tintColor;});
                  }

                  (function(item) {
                      item.height = Qt.binding(function() {
                          return navigationBar.height;
                      });
                  })(child);
              }
          }

          onNavigationItemChanged:  {
              var data = { object: navigationItem}
              if (index >= navigationItems.count) {
                  navigationItems.append(data);
              } else {
                  navigationItems.set(index,data);
              }

              if (!navigationItem) {
                  currentLeftButtonItems = dummyItemModel;
                  currentRightButtonItems = dummyItemModel;
                  return;
              }

              currentLeftButtonItems = Qt.binding(function() {
                return navigationItem.leftBarButtonItems;
              });

              currentRightButtonItems = Qt.binding(function() {
                return navigationItem.rightBarButtonItems;
              });

              setup(navigationItem.rightBarButtonItems);
              setup(navigationItem.leftBarButtonItems);
          }

          Component.onCompleted: {
              if (model.object.hasOwnProperty("navigationItem")) {
                  navigationItem = Qt.binding(function() {
                      return model.object.navigationItem;
                  });
              }

              if (model.object.hasOwnProperty("title")) {
                  title = Qt.binding(function() {
                      return model.object.title;
                  });
              }
              navigationBar.navigationItem = navigationItem;

              var object = creator.createObject(stack);

              stack.push(object);
          }

          Component.onDestruction: {
              stack.pop();
              navigationItems.remove(navigationItems.count - 1);
              if (navigationItems.count > 0)
                navigationBar.navigationItem = navigationItems.get(navigationItems.count - 1).object;
              else
                navigationBar.navigationItem = dummyNavigationItem;
          }
      }
  }
}
