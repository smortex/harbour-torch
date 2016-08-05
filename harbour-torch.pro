# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-torch

CONFIG += sailfishapp

SOURCES += src/harbour-torch.cpp \
    src/flashlight.cpp

OTHER_FILES += qml/harbour-torch.qml \
    qml/cover/CoverPage.qml \
    rpm/$${TARGET}.spec \
    rpm/$${TARGET}.yaml \
    $${TARGET}.desktop
    translations/*.ts \

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/$${TARGET}-fr.ts

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/pages/Settings.qml \
    qml/pages/FailurePage.qml

HEADERS += \
    src/flashlight.h

