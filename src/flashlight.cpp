#include <iostream>
#include <fstream>
#include "flashlight.h"

FlashLight::FlashLight()
{
    current_state = false;
}

void FlashLight::enable()
{
    write_value(current_state = 1);
}

void FlashLight::disable()
{
    write_value(current_state = 0);
}

void FlashLight::toggle()
{
    if (current_state)
        disable();
    else
        enable();
}

void FlashLight::write_value(int value)
{
    std::ofstream io;
    io.open("/sys/kernel/debug/flash_adp1650/mode");
    io << value;
    io.close();
}
