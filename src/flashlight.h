#ifndef FLASHLIGHT_H
#define FLASHLIGHT_H

#include <QObject>
#include <QStringList>

class FlashLight : public QObject
{
    Q_OBJECT
public:
    FlashLight();
    Q_INVOKABLE void enable();
    Q_INVOKABLE void disable();
    Q_INVOKABLE void toggle();
    Q_INVOKABLE bool state();
signals:
    void failure();
    void stateChanged(bool arg);
private:
    bool current_state;
    void write_value(int value);
    QStringList filenames;
};

#endif // FLASHLIGHT_H
