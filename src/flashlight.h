#ifndef FLASHLIGHT_H
#define FLASHLIGHT_H

#include <QObject>

class FlashLight : public QObject
{
    Q_OBJECT
public:
    FlashLight();
    Q_INVOKABLE void enable();
    Q_INVOKABLE void disable();
    Q_INVOKABLE void toggle();
private:
    bool current_state;
    void write_value(int value);
};

#endif // FLASHLIGHT_H
