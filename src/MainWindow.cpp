#include "MainWindow.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QGroupBox>
#include <QHeaderView>
#include <QMessageBox>
#include <QStatusBar>

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent) {
    configurarInterfaz();
    conectarSenalesConLambdas();
    actualizarTabla();
}

void MainWindow::configurarInterfaz() {
    setWindowTitle("SGTE-UNSA | Sistema de Gestion de Tramites y Expedientes Academicos (EPIS)");
    resize(1160, 680);

    auto* widgetCentral = new QWidget(this);
    setCentralWidget(widgetCentral);
    auto* layoutPrincipal = new QVBoxLayout(widgetCentral);
    layoutPrincipal->setSpacing(10);
    layoutPrincipal->setContentsMargins(14, 14, 14, 14);

    auto* lblTitulo = new QLabel(
        "<b>UNIVERSIDAD NACIONAL DE SAN AGUSTIN DE AREQUIPA - EPIS</b><br>"
        "<span style='font-size:11pt;'>SGTE-UNSA: Gestion de Tramites Academicos (Semestre " +
        QString::fromStdString(ConfiguracionUNSA::instancia().getSemestreActivo()) + ")</span>",
        this);
    lblTitulo->setStyleSheet(
        "background-color: #7A1315; color: white; padding: 10px; border-radius: 5px;");
    layoutPrincipal->addWidget(lblTitulo);

    auto* grpRegistro = new QGroupBox("1. Registro de Nuevo Expediente (Factory Method + Strategy + Decorator)", this);
    auto* gridRegistro = new QGridLayout(grpRegistro);

    txtCodigo_ = new QLineEdit(QString::fromStdString(controlador_.generarSiguienteCodigo()), this);
    cmbTipoTramite_ = new QComboBox(this);
    cmbTipoTramite_->addItems({"Matricula", "Carta Practicas", "Grado Bachiller"});

    txtDni_ = new QLineEdit(this);
    txtDni_->setPlaceholderText("8 digitos (ej. 73918273)");
    txtDni_->setMaxLength(8);

    txtEstudiante_ = new QLineEdit(this);
    txtEstudiante_->setPlaceholderText("Apellidos y nombres del estudiante");

    cmbModalidadTasa_ = new QComboBox(this);
    cmbModalidadTasa_->addItems({"Regular", "Beca 50%", "Exonerado"});

    chkUrgente_ = new QCheckBox("Atencion Urgente (+S/ 20.00 | Prioridad Maxima - Decorator)", this);

    btnRegistrar_ = new QPushButton("Registrar Expediente", this);
    btnRegistrar_->setStyleSheet(
        "background-color: #7A1315; color: white; font-weight: bold; padding: 6px 14px;");

    gridRegistro->addWidget(new QLabel("Codigo:", this), 0, 0);
    gridRegistro->addWidget(txtCodigo_, 0, 1);
    gridRegistro->addWidget(new QLabel("Tipo de Tramite:", this), 0, 2);
    gridRegistro->addWidget(cmbTipoTramite_, 0, 3);
    gridRegistro->addWidget(new QLabel("Modalidad (Strategy):", this), 0, 4);
    gridRegistro->addWidget(cmbModalidadTasa_, 0, 5);

    gridRegistro->addWidget(new QLabel("DNI Alumno:", this), 1, 0);
    gridRegistro->addWidget(txtDni_, 1, 1);
    gridRegistro->addWidget(new QLabel("Estudiante:", this), 1, 2);
    gridRegistro->addWidget(txtEstudiante_, 1, 3);
    gridRegistro->addWidget(chkUrgente_, 1, 4);
    gridRegistro->addWidget(btnRegistrar_, 1, 5);

    layoutPrincipal->addWidget(grpRegistro);

    auto* grpFiltros = new QGroupBox("2. Consulta, Filtrado Funcional (Lambdas + STL) y Control de Estado", this);
    auto* layoutFiltros = new QHBoxLayout(grpFiltros);

    txtBuscar_ = new QLineEdit(this);
    txtBuscar_->setPlaceholderText("Buscar por codigo, DNI, estudiante o tipo (std::copy_if + lambda)...");

    cmbFiltroEstado_ = new QComboBox(this);
    cmbFiltroEstado_->addItems({"Todos", "Pendiente", "En Revision", "Atendido"});

    btnOrdenarPrioridad_ = new QPushButton("Ordenar por Prioridad (operator<)", this);
    btnMarcarRevision_ = new QPushButton("Marcar 'En Revision'", this);
    btnMarcarAtendido_ = new QPushButton("Marcar 'Atendido'", this);
    btnEliminar_ = new QPushButton("Eliminar Seleccionado", this);

    layoutFiltros->addWidget(new QLabel("Filtro:", this));
    layoutFiltros->addWidget(txtBuscar_, 2);
    layoutFiltros->addWidget(new QLabel("Estado:", this));
    layoutFiltros->addWidget(cmbFiltroEstado_);
    layoutFiltros->addWidget(btnOrdenarPrioridad_);
    layoutFiltros->addWidget(btnMarcarRevision_);
    layoutFiltros->addWidget(btnMarcarAtendido_);
    layoutFiltros->addWidget(btnEliminar_);

    layoutPrincipal->addWidget(grpFiltros);

    tablaTramites_ = new QTableWidget(0, 8, this);
    tablaTramites_->setHorizontalHeaderLabels({
        "Codigo", "Tipo de Tramite", "Prioridad", "DNI",
        "Estudiante", "Modalidad (Strategy)", "Costo Final (S/)", "Estado"
    });
    tablaTramites_->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    tablaTramites_->setSelectionBehavior(QAbstractItemView::SelectRows);
    tablaTramites_->setSelectionMode(QAbstractItemView::SingleSelection);
    tablaTramites_->setEditTriggers(QAbstractItemView::NoEditTriggers);
    tablaTramites_->setAlternatingRowColors(true);
    layoutPrincipal->addWidget(tablaTramites_, 1);

    lblResumenMetricas_ = new QLabel(this);
    lblResumenMetricas_->setStyleSheet(
        "background-color: #F1F5F9; color: #0F172A; border: 1px solid #94A3B8; "
        "border-radius: 4px; padding: 7px; font-weight: bold;");
    layoutPrincipal->addWidget(lblResumenMetricas_);

    auto* grpHilo = new QGroupBox("3. Auditoria y Exportacion en Segundo Plano (Multithreading con QThread + Functor)", this);
    auto* layoutHilo = new QHBoxLayout(grpHilo);

    btnAuditarHilo_ = new QPushButton("Auditar Lote y Generar Reporte (Hilo Secundario)", this);
    btnAuditarHilo_->setStyleSheet("font-weight: bold; padding: 5px 12px;");

    barraProgreso_ = new QProgressBar(this);
    barraProgreso_->setRange(0, 100);
    barraProgreso_->setValue(0);

    lblEstadoHilo_ = new QLabel("Listo para ejecutar auditoria concurrente.", this);

    layoutHilo->addWidget(btnAuditarHilo_);
    layoutHilo->addWidget(barraProgreso_, 1);
    layoutHilo->addWidget(lblEstadoHilo_, 2);

    layoutPrincipal->addWidget(grpHilo);
    statusBar()->showMessage("Persistencia activa en archivo local: " +
                             QString::fromStdString(ConfiguracionUNSA::instancia().getRutaArchivo()));
}

void MainWindow::conectarSenalesConLambdas() {
    connect(btnRegistrar_, &QPushButton::clicked, this, [this]() {
        try {
            controlador_.registrarTramite(
                txtCodigo_->text().trimmed().toStdString(),
                cmbTipoTramite_->currentText().toStdString(),
                txtDni_->text().trimmed().toStdString(),
                txtEstudiante_->text().trimmed().toStdString(),
                cmbModalidadTasa_->currentText().toStdString(),
                chkUrgente_->isChecked());

            limpiarFormulario();
            actualizarTabla();
            statusBar()->showMessage("Expediente registrado y persistido exitosamente en CSV.", 4000);
        } catch (const ExcepcionTramite& ex) {
            QMessageBox::warning(this, "Validacion de Expediente", QString::fromStdString(ex.what()));
        }
    });

    connect(txtBuscar_, &QLineEdit::textChanged, this, [this](const QString&) {
        actualizarTabla();
    });

    connect(cmbFiltroEstado_, &QComboBox::currentTextChanged, this, [this](const QString&) {
        actualizarTabla();
    });

    connect(btnOrdenarPrioridad_, &QPushButton::clicked, this, [this]() {
        controlador_.ordenarPorPrioridad();
        actualizarTabla();
        statusBar()->showMessage("Expedientes ordenados por nivel de prioridad (std::sort + operator<).", 4000);
    });

    connect(btnMarcarRevision_, &QPushButton::clicked, this, [this]() {
        int fila = tablaTramites_->currentRow();
        if (fila < 0) {
            QMessageBox::information(this, "Seleccion requerida", "Seleccione un expediente de la tabla.");
            return;
        }
        std::string codigo = tablaTramites_->item(fila, 0)->text().toStdString();
        controlador_.cambiarEstado(codigo, "En Revision");
        actualizarTabla();
    });

    connect(btnMarcarAtendido_, &QPushButton::clicked, this, [this]() {
        int fila = tablaTramites_->currentRow();
        if (fila < 0) {
            QMessageBox::information(this, "Seleccion requerida", "Seleccione un expediente de la tabla.");
            return;
        }
        std::string codigo = tablaTramites_->item(fila, 0)->text().toStdString();
        controlador_.cambiarEstado(codigo, "Atendido");
        actualizarTabla();
    });

    connect(btnEliminar_, &QPushButton::clicked, this, [this]() {
        int fila = tablaTramites_->currentRow();
        if (fila < 0) {
            QMessageBox::information(this, "Seleccion requerida", "Seleccione un expediente para eliminar.");
            return;
        }
        std::string codigo = tablaTramites_->item(fila, 0)->text().toStdString();
        controlador_.eliminarTramite(codigo);
        actualizarTabla();
        statusBar()->showMessage("Expediente eliminado del repositorio generico.", 4000);
    });

    connect(btnAuditarHilo_, &QPushButton::clicked, this, [this]() {
        if (hiloActual_ && hiloActual_->isRunning()) {
            return;
        }
        btnAuditarHilo_->setEnabled(false);
        barraProgreso_->setValue(0);
        lblEstadoHilo_->setText("Iniciando hilo de auditoria...");

        hiloActual_ = new HiloProcesador(controlador_.obtenerTodos(), "reporte_auditoria.txt", this);

        connect(hiloActual_, &HiloProcesador::progresoActualizado, this,
                [this](int porcentaje, const QString& detalle) {
                    barraProgreso_->setValue(porcentaje);
                    lblEstadoHilo_->setText(detalle);
                });

        connect(hiloActual_, &HiloProcesador::procesamientoFinalizado, this,
                [this](const QString& resumen) {
                    lblEstadoHilo_->setText(resumen);
                    btnAuditarHilo_->setEnabled(true);
                    QMessageBox::information(this, "Auditoria Concurrente Finalizada", resumen);
                });

        connect(hiloActual_, &QThread::finished, hiloActual_, &QObject::deleteLater);
        hiloActual_->start();
    });
}

void MainWindow::actualizarTabla() {
    auto lista = controlador_.obtenerFiltrados(
        txtBuscar_->text().trimmed().toStdString(),
        cmbFiltroEstado_->currentText().toStdString());

    tablaTramites_->setRowCount(static_cast<int>(lista.size()));

    for (std::size_t i = 0; i < lista.size(); ++i) {
        const auto& t = lista[i];
        int fila = static_cast<int>(i);

        QString textoPrioridad;
        switch (t->obtenerPrioridad()) {
            case 0: textoPrioridad = "0 - URGENTE"; break;
            case 1: textoPrioridad = "1 - Alta"; break;
            case 2: textoPrioridad = "2 - Media"; break;
            default: textoPrioridad = "3 - Normal"; break;
        }

        tablaTramites_->setItem(fila, 0, new QTableWidgetItem(QString::fromStdString(t->getCodigo())));
        tablaTramites_->setItem(fila, 1, new QTableWidgetItem(QString::fromStdString(t->obtenerTipo())));
        tablaTramites_->setItem(fila, 2, new QTableWidgetItem(textoPrioridad));
        tablaTramites_->setItem(fila, 3, new QTableWidgetItem(QString::fromStdString(t->getDni())));
        tablaTramites_->setItem(fila, 4, new QTableWidgetItem(QString::fromStdString(t->getNombre())));
        tablaTramites_->setItem(fila, 5, new QTableWidgetItem(QString::fromStdString(t->getModalidadTasa())));
        tablaTramites_->setItem(fila, 6, new QTableWidgetItem(QString::number(t->calcularCostoFinal(), 'f', 2)));
        tablaTramites_->setItem(fila, 7, new QTableWidgetItem(QString::fromStdString(t->getEstado())));
    }

    lblResumenMetricas_->setText(
        QString("Total Expedientes: %1   |   Pendientes (std::count_if): %2   |   "
                "Urgentes (Decorator): %3   |   Liquidacion Total (std::accumulate): S/ %4")
            .arg(controlador_.contarTotal())
            .arg(controlador_.contarPendientes())
            .arg(controlador_.contarUrgentes())
            .arg(QString::number(controlador_.obtenerRecaudacionTotal(), 'f', 2)));
}

void MainWindow::limpiarFormulario() {
    txtCodigo_->setText(QString::fromStdString(controlador_.generarSiguienteCodigo()));
    txtDni_->clear();
    txtEstudiante_->clear();
    chkUrgente_->setChecked(false);
}
