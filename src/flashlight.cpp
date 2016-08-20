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
    if (write_value(!current_state)) {
        current_state = !current_state;
        emit stateChanged();
    }
}

bool FlashLight::state()
{
    return current_state;
}

bool FlashLight::write_value(int value)
{
    foreach (QString filename, filenames) {
        QFile file(filename);
        QTextStream out(&file);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            out << value;
            file.close();
            return true;
        }
    }

    emit failure();
    return false;
}
