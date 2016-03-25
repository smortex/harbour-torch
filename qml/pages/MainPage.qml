/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
                    var dialog = pageStack.push(Qt.resolvedUrl("Settings.qml"), { enableOnStart: dbGet('enable_on_start') === '1' })
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
            console.log("WRITE")
        })
    }

    Component.onCompleted: {
        if (dbGet('enable_on_start') === '1')
            sw.checked = true
    }
}
