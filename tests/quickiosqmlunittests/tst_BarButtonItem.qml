import QtQuick 2.0
import QtTest 1.0
import QuickIOS 0.1
import QtQuick.Layouts 1.1
import QuickIOS.utils 0.1

NavigationController {
    id: window
    height: 640 // For desktop
    width: 480
    visible: true
    tintColor : "#ff0000"
    objectName: "Navigation Controller"

    initialViewController : ViewController {
        id: rootView
        objectName : "RootView";
        title : "Bar Button Item Test"

        navigationItem : NavigationItem {
            leftBarButtonItem : BarButtonItem {
                id: leftBarButtonItem
                title : "Test"
            }
        }

        Row {
            x: 10
            y: 10
            spacing : 20

            BarButtonItem {
                id : button1
                title : "Button with Title Only"


                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Vertical
                }
            }

            BarButtonItem {
                id : button2
                image : "./img/ic_play.png"

                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Vertical
                }
            }

            BarButtonItem {
                id : button3
                imageSourceSize : Qt.size(25,25)
                image : "./img/ic_play.png"

                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Vertical
                }

            }

            BarButtonItem {
                id : button4
                imageSourceSize : Qt.size(25,25)
                image : "./img/ic_play.png"
                title: "Play"

                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Vertical
                }

                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Horizontal
                }

            }

            BarButtonItem {
                id : button5

                imageSourceSize : Qt.size(25,25)
                image : "./img/ic_play.png"
                title: "Play"

                fontSize: 12


                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Vertical
                }

                Ruler {
                    anchors.fill: parent
                    orientation: Qt.Horizontal
                }
            }

        }

        Row {
            x: 10
            y: 100
            spacing : 20

            BarButtonItem {
                id : button6

                imageSourceSize : Qt.size(25,25)
                image : "./img/ic_play.png"
                title: "Play"
                renderOriginalImage: true
            }
        }


    }


    TestCase {
        name: "BarButtonItem"
        when : windowShown

        function test_preview() {
            var fontHeight16 = button1.height
            compare(button2.width,50 + 16);
            compare(button2.height,50);

            compare(button3.width,25 + 16);
            compare(button3.height,25);

            compare(button4.height,25 + fontHeight16);

            wait(TestEnv.waitTime);
        }
    }


}
