import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("SettingsPage.qml"), { enableOnStart: dbGet('enable_on_start') === '1' })
                    dialog.accepted.connect(function () {
                        dbSet('enable_on_start', dialog.enableOnStart)
                    })
                }
            }
        }

        Switch {
            id: sw
            anchors.fill: parent
            icon.source: "image://theme/icon-m-day"
            onCheckedChanged: {
                if (sw.checked) torch.enable(); else torch.disable();
            }
        }

        Connections {
            target: torch
            onStateChanged: {
                sw.checked = torch.state()
            }
            onFailure: {
                pageStack.replace(Qt.resolvedUrl("FailurePage.qml"), null, PageStackAction.Immediate)
            }
        }
    }

    function db() {
        return LocalStorage.openDatabaseSync("torch", "1.0", "Torch preferences", 10240, dbInit)
    }

    function dbInit(db) {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE settings (key TEXT, value TEXT)')
            tx.executeSql('INSERT INTO settings VALUES (?, ?)', ['enable_on_start', '0'])
        })
        db.changeVersion('', '1.0')
    }

    function dbGet(key) {
        var res

        db().transaction(function (tx) {
            var rs = tx.executeSql('SELECT * FROM settings WHERE key = ?', [key])
            res = (rs.rows.length === 1) ? rs.rows.item(0).value : ''
        })

        return res
    }

    function dbSet(key, value) {
        db().transaction(function (tx) {
            tx.executeSql('UPDATE settings SET value = ? WHERE key = ?', [value, key])
        })
    }

    Component.onCompleted: {
        if (dbGet('enable_on_start') === '1')
            sw.checked = true
    }
}
