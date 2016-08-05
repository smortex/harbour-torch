import QtQuick 2.0
import Sailfish.Silica 1.0

import "../pages"

CoverBackground {
    Image {
        anchors.centerIn: parent
        source: "image://theme/icon-m-day"
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-location"
            onTriggered: torch.toggle()

        }
    }
}
