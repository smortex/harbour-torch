import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Label {
        text: ":(\n%1".arg(qsTr("This device is not supported"))
        font.pixelSize: Theme.fontSizeExtraLarge
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        color: Theme.highlightColor
        anchors.fill: parent
    }
}

