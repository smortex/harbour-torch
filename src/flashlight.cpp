#include <QFile>
#include <QTextStream>

#include "flashlight.h"

FlashLight::FlashLight()
{
    current_state = false;
}

void FlashLight::enable()
{
    if (current_state != true) {
        write_value(current_state = true);
        emit stateChanged(current_state);
    }
}

void FlashLight::disable()
{
    if (current_state != false) {
        write_value(current_state = false);
        emit stateChanged(current_state);
    }
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

void FlashLight::write_value(int value)
{
    QFile file("/sys/kernel/debug/flash_adp1650/mode");
    QTextStream out(&file);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        out << value;
        file.close();
    } else
        emit failure();
}
