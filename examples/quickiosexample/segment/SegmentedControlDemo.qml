import QtQuick 2.0
import QuickIOS 0.1

ViewController {
    id: viewController

    title: "Segmented Control"

    SegmentedViewController {
        anchors.fill: parent

        Segment {
            title : "Blue"
            ViewController {
                backgroundColor : "blue"
            }
        }

        Segment {
            title : "Red"
            ViewController {
                backgroundColor : "red"
            }
        }


        Segment {
            title : "Black"
            ViewController {
                backgroundColor : "black"
            }
        }
    }

}

