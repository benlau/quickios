import QtQuick 2.0
import QuickIOS 0.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ViewController {
    width: 100
    height: 62
    color : "#ffffff"
    title : "Tool Bar"

    toolBarItems: RowLayout {
        BarButtonItem {
            imageSourceSize: Qt.size(25,25)
            image : "../img/ic_play.png"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
