#include <QFile>
#include <QTextStream>

#include "flashlight.h"

FlashLight::FlashLight()
{
    filenames << "/sys/class/leds/led:flash_torch/brightness"; // LG Nexus 5, Fairphone Fairphone 2
    filenames << "/sys/class/leds/torch-flash/flash_light";    // Motorola Photon Q
    filenames << "/sys/class/leds/torch-light0/brightness";    // Intex Aqua Fish
    filenames << "/sys/kernel/debug/flash_adp1650/mode";       // Jolla

    current_state = false;
}

void FlashLight::enable()
{
     if (write_value(true))
         emit stateChanged(current_state);
}

void FlashLight::disable()
{
     if (write_value(false))
         emit stateChanged(current_state);
}

void FlashLight::toggle()
{
    if (current_state)
        disable();
    else
        enable();
}

bool FlashLight::state()
{
    return current_state;
}

bool FlashLight::write_value(int value)
{
    if (current_state == value)
        return false;

    foreach (QString filename, filenames) {
        QFile file(filename);
        QTextStream out(&file);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            out << value;
            current_state = value;
            file.close();
            return true;
        }
    }

    emit failure();
    return false;
}
