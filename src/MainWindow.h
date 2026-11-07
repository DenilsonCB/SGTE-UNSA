#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLineEdit>
#include <QComboBox>
#include <QCheckBox>
#include <QPushButton>
#include <QTableWidget>
#include <QProgressBar>
#include <QLabel>
#include "ControladorTramites.h"
#include "HiloProcesador.h"

class MainWindow : public QMainWindow {
    Q_OBJECT

private:
    ControladorTramites controlador_;
    HiloProcesador* hiloActual_ = nullptr;

    QLineEdit* txtCodigo_;
    QComboBox* cmbTipoTramite_;
    QLineEdit* txtDni_;
    QLineEdit* txtEstudiante_;
    QComboBox* cmbModalidadTasa_;
    QCheckBox* chkUrgente_;
    QPushButton* btnRegistrar_;

    QLineEdit* txtBuscar_;
    QComboBox* cmbFiltroEstado_;
    QPushButton* btnOrdenarPrioridad_;
    QPushButton* btnMarcarRevision_;
    QPushButton* btnMarcarAtendido_;
    QPushButton* btnEliminar_;

    QTableWidget* tablaTramites_;
    QLabel* lblResumenMetricas_;

    QPushButton* btnAuditarHilo_;
    QProgressBar* barraProgreso_;
    QLabel* lblEstadoHilo_;

    void configurarInterfaz();
    void conectarSenalesConLambdas();
    void actualizarTabla();
    void limpiarFormulario();

public:
    explicit MainWindow(QWidget* parent = nullptr);
    ~MainWindow() override = default;
};

#endif // MAINWINDOW_H
