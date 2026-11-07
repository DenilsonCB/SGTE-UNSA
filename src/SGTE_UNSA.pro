QT       += core gui widgets
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

TARGET = SGTE_UNSA
TEMPLATE = app

SOURCES += \
    main.cpp \
    Tramite.cpp \
    MainWindow.cpp

HEADERS += \
    Excepciones.h \
    EstrategiaTasa.h \
    Tramite.h \
    Repositorio.h \
    HiloProcesador.h \
    ControladorTramites.h \
    MainWindow.h
