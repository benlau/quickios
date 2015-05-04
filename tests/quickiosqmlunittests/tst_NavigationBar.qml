import QtQuick 2.0
import QtQuick.Window 2.2
import QtTest 1.0
import QtQml.Models 2.1
import QuickIOS 0.1
import QuickIOS.utils 0.1


Rectangle {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true


    TestCase {
        name : "NavigationBar"
        when : windowShown

        Component {
            id: navigationControllerLongTitleView
            NavigationController {
                id: navigationController
                property alias ruler : rulerItem

                anchors.fill: parent
                initialViewController: ViewController {
                    title : "_______________Example_______________"
                    navigationItem: NavigationItem {

                        leftBarButtonItems: ObjectModel {

                            BarButtonItem {
                                title: "Btn1"
                            }

                            BarButtonItem {
                                title: "Btn2"
                            }

                        }

                        rightBarButtonItems: ObjectModel {
                            BarButtonItem {
                                title : "Btn3"
                            }
                        }
                    }
                }

                Ruler {
                    id: rulerItem
//                    parent: navigationController.navigationBar.currentTitleItem.parent
                    orientation: Qt.Horizontal
//                    anchors.fill: navigationController.navigationBar.currentTitleItem
                }
            }
        }

        // The default title view may shrink the text if it is too long.
        function test_titleView_long() {
            var nc = navigationControllerLongTitleView.createObject(window);
            nc.ruler.parent = nc.navigationBar.currentTitleItem.parent
            nc.ruler.anchors.fill =  nc.navigationBar.currentTitleItem
            wait(500);
            compare(nc.ruler.width < 270,true) // Font size can be different in differnet system.
            compare(nc.navigationBar.currentTitleItem.paintedWidth * nc.navigationBar.currentTitleItem.scale  <= nc.ruler.width,true)
            wait(TestEnv.waitTime)
        }

    }

}
