import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property bool enableOnStart

    Column {
        anchors.fill: parent

        DialogHeader {
            id: header
            title: qsTr("Settings")
        }

        TextSwitch {
            id: enableOnStartSwitch
            text: qsTr("Automatically switch the torch on when the application starts")
            checked: enableOnStart
        }
    }

    onDone: {
        enableOnStart = enableOnStartSwitch.checked
    }
}

