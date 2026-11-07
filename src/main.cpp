#include <QApplication>
#include <QStyleFactory>
#include <QPalette>
#include "MainWindow.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    app.setStyle(QStyleFactory::create("Fusion"));

    QPalette paletaClara;
    paletaClara.setColor(QPalette::Window, QColor("#F8FAFC"));
    paletaClara.setColor(QPalette::WindowText, QColor("#0F172A"));
    paletaClara.setColor(QPalette::Base, QColor("#FFFFFF"));
    paletaClara.setColor(QPalette::AlternateBase, QColor("#F1F5F9"));
    paletaClara.setColor(QPalette::ToolTipBase, QColor("#FFFFFF"));
    paletaClara.setColor(QPalette::ToolTipText, QColor("#0F172A"));
    paletaClara.setColor(QPalette::Text, QColor("#0F172A"));
    paletaClara.setColor(QPalette::Button, QColor("#E2E8F0"));
    paletaClara.setColor(QPalette::ButtonText, QColor("#0F172A"));
    paletaClara.setColor(QPalette::Highlight, QColor("#7A1315"));
    paletaClara.setColor(QPalette::HighlightedText, QColor("#FFFFFF"));
    app.setPalette(paletaClara);

    MainWindow ventana;
    ventana.show();
    return app.exec();
}
