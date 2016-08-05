import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

import harbour.torch 1.0

ApplicationWindow
{
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Torch {
        id: torch
    }

    Component.onDestruction : torch.disable()
}


