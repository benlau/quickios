import QtQuick 2.2
import QtQuick.Window 2.1
import "appdelegate.js" as AppDelegate

Rectangle {
  property string objectName: "ViewController"

  property var navigationView;

  property NavigationItem navigationItem : NavigationItem {}

  signal viewWillAppear(bool animated)
  signal viewDidAppear(bool animated)
  signal viewWillDisappear(bool animated)
  signal viewDidDisappear(bool animated)

  id: viewController
  color: "#ffffff"


  signal pageChanged(var dstItem)

  function presentView(view) {
    AppDelegate.application.presentView(view);
  }

  function dismissView() {
    AppDelegate.application.pop();
  }

}
