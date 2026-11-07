#ifndef HILOPROCESADOR_H
#define HILOPROCESADOR_H

#include <QThread>
#include <QString>
#include <vector>
#include <memory>
#include <fstream>
#include <iomanip>
#include "Tramite.h"

struct EvaluadorPrioridadFunctor {
    bool operator()(const std::shared_ptr<Tramite>& t) const {
        return t->obtenerPrioridad() <= 1 && t->getEstado() != "Atendido";
    }
};

class HiloProcesador : public QThread {
    Q_OBJECT

private:
    std::vector<std::shared_ptr<Tramite>> copiaTramites_;
    std::string rutaReporte_;

public:
    HiloProcesador(std::vector<std::shared_ptr<Tramite>> tramites,
                   std::string rutaReporte,
                   QObject* parent = nullptr)
        : QThread(parent),
          copiaTramites_(std::move(tramites)),
          rutaReporte_(std::move(rutaReporte)) {}

signals:
    void progresoActualizado(int porcentaje, const QString& detalle);
    void procesamientoFinalizado(const QString& resumenFinal);

protected:
    void run() override {
        std::ofstream reporte(rutaReporte_, std::ios::out | std::ios::trunc);
        reporte << "===============================================================\n";
        reporte << "   REPORTE DE AUDITORIA Y LIQUIDACION DE EXPEDIENTES - UNSA    \n";
        reporte << "   Semestre Academico: " << ConfiguracionUNSA::instancia().getSemestreActivo() << "\n";
        reporte << "===============================================================\n\n";

        int total = static_cast<int>(copiaTramites_.size());
        int prioritariosPendientes = 0;
        double recaudacionTotal = 0.0;
        EvaluadorPrioridadFunctor esPrioritario;

        if (total == 0) {
            emit progresoActualizado(100, "Sin expedientes para procesar.");
            emit procesamientoFinalizado("No hay expedientes registrados.");
            return;
        }

        for (int i = 0; i < total; ++i) {
            const auto& t = copiaTramites_[i];
            if (esPrioritario(t)) {
                ++prioritariosPendientes;
            }
            recaudacionTotal += t->calcularCostoFinal();

            reporte << (i + 1) << ". " << *t << "\n";

            QThread::msleep(180);

            int porcentaje = ((i + 1) * 100) / total;
            QString msg = QString("Verificando expediente %1 (%2/%3)...")
                              .arg(QString::fromStdString(t->getCodigo()))
                              .arg(i + 1)
                              .arg(total);
            emit progresoActualizado(porcentaje, msg);
        }

        reporte << "\n---------------------------------------------------------------\n";
        reporte << "Total de expedientes auditados : " << total << "\n";
        reporte << "Alertas de prioridad alta/urg. : " << prioritariosPendientes << "\n";
        reporte << "Liquidacion total acumulada    : S/ "
                << std::fixed << std::setprecision(2) << recaudacionTotal << "\n";
        reporte.close();

        QString resumen = QString("Auditoria completada en hilo secundario: %1 expedientes, %2 prioritarios pendientes. Archivo generado: %3")
                              .arg(total)
                              .arg(prioritariosPendientes)
                              .arg(QString::fromStdString(rutaReporte_));
        emit procesamientoFinalizado(resumen);
    }
};

#endif // HILOPROCESADOR_H
