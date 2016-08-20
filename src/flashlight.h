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
    Q_PROPERTY(bool state READ state NOTIFY stateChanged)
signals:
    void failure();
    void stateChanged();
private:
    bool current_state;
    bool write_value(int value);
    bool state();
    QStringList filenames;
};

#endif // FLASHLIGHT_H
