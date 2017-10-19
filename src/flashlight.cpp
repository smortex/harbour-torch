#include <QFile>
#include <QTextStream>
#include <QtDBus/QtDBus>

#include <QDebug>

#include "flashlight.h"

static const QString FLASHLIGHT_SERVICE = "com.jolla.settings.system.flashlight";
static const QString FLASHLIGHT_PATH = "/com/jolla/settings/system/flashlight";
static const QString FLASHLIGHT_INTERFACE = FLASHLIGHT_SERVICE;

FlashLight::FlashLight()
{
    filenames << "/sys/class/leds/led:flash_torch/brightness"; // LG Nexus 5, Fairphone Fairphone 2
    filenames << "/sys/class/leds/torch-flash/flash_light";    // Motorola Photon Q
    filenames << "/sys/class/leds/torch-light0/brightness";    // Intex Aqua Fish
    filenames << "/sys/kernel/debug/flash_adp1650/mode";       // Jolla
    filenames << "/sys/class/leds/led:torch_0/brightness";     // Xperia X

    current_state = false;

    if (QDBusConnection::sessionBus().connect(FLASHLIGHT_SERVICE,
                                              FLASHLIGHT_PATH,
                                              FLASHLIGHT_INTERFACE,
                                              "flashlightOnChanged",
                                              this,
                                              SLOT(flashlightOnChangedSlot(bool)))) {
        qDebug() << "Connected to DBus flashlightOnChanged event";
    }
}

void FlashLight::flashlightOnChangedSlot(bool state)
{
    setstate(state);
}

void FlashLight::enable()
{
     if (current_state != true)
         toggle();
}

void FlashLight::disable()
{
     if (current_state != false)
         toggle();
}

void FlashLight::toggle()
{
    if (!write_value(!current_state) && !toggleDBus()) {
        emit failure();
    }
}

bool FlashLight::toggleDBus() {
    if (!QDBusConnection::sessionBus().isConnected()) {
        return false;
    }

    QDBusInterface iface(FLASHLIGHT_SERVICE, FLASHLIGHT_PATH, FLASHLIGHT_INTERFACE, QDBusConnection::sessionBus());

    if (iface.isValid()) {
        QDBusMessage reply = iface.call("toggleFlashlight");
        if (reply.type() == QDBusMessage::ReplyMessage) {
            qDebug() << "Flashlight toggled through DBus";
            return true;
        }
    }
    return false;
}

bool FlashLight::state()
{
    return current_state;
}

void FlashLight::setstate(bool state)
{
    current_state = state;
    emit stateChanged();
}

bool FlashLight::write_value(int value)
{
    foreach (QString filename, filenames) {
        QFile file(filename);
        QTextStream out(&file);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            out << value;
            file.close();
            setstate(value);
            qDebug() << "Flashlight toggled through" << filename;
            return true;
        }
    }
    return false;
}
