import QtQuick
import QtQuick.Window

Window {
    width: 400
    height: 40
    visible: true

    Rectangle {
        anchors.fill: parent
        color: "black"

        Text {
            anchors.centerIn: parent
            text: "Hello Quickshell"
            color: "white"
        }
    }
}