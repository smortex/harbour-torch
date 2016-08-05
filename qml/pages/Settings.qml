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
            text: qsTr("Switch the torch on when the application starts")
            description: qsTr("Allows the torch to be switched on from the locked screen shortcuts before typing-in the unlock code")
            checked: enableOnStart
        }
    }

    onDone: {
        enableOnStart = enableOnStartSwitch.checked
    }
}

