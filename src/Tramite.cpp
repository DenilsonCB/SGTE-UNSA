#include "Tramite.h"
#include <algorithm>
#include <cctype>

Tramite::Tramite(std::string codigo,
                 std::string dni,
                 std::string nombre,
                 double tasaBase,
                 std::shared_ptr<IEstrategiaTasa> estrategia,
                 std::string estado)
    : codigo_(std::move(codigo)),
      dniEstudiante_(std::move(dni)),
      nombreEstudiante_(std::move(nombre)),
      estado_(std::move(estado)),
      tasaBase_(tasaBase),
      estrategiaTasa_(std::move(estrategia)) {}

std::string Tramite::serializarCSV() const {
    std::ostringstream oss;
    oss << codigo_ << ";"
        << obtenerTipo() << ";"
        << dniEstudiante_ << ";"
        << nombreEstudiante_ << ";"
        << getModalidadTasa() << ";"
        << (esUrgente() ? "SI" : "NO") << ";"
        << std::fixed << std::setprecision(2) << calcularCostoFinal() << ";"
        << estado_;
    return oss.str();
}

std::ostream& operator<<(std::ostream& os, const Tramite& t) {
    os << "[" << t.codigo_ << "] " << t.obtenerTipo()
       << " | DNI: " << t.dniEstudiante_
       << " | Estudiante: " << t.nombreEstudiante_
       << " | Costo: S/ " << std::fixed << std::setprecision(2) << t.calcularCostoFinal()
       << " | Estado: " << t.estado_;
    return os;
}

TramiteMatricula::TramiteMatricula(std::string codigo,
                                   std::string dni,
                                   std::string nombre,
                                   std::shared_ptr<IEstrategiaTasa> estrategia,
                                   std::string estado)
    : Tramite(std::move(codigo), std::move(dni), std::move(nombre), 30.00, std::move(estrategia), std::move(estado)) {}

double TramiteMatricula::calcularCostoFinal() const {
    return estrategiaTasa_ ? estrategiaTasa_->calcularMonto(tasaBase_) : tasaBase_;
}

TramiteCartaPracticas::TramiteCartaPracticas(std::string codigo,
                                             std::string dni,
                                             std::string nombre,
                                             std::shared_ptr<IEstrategiaTasa> estrategia,
                                             std::string estado)
    : Tramite(std::move(codigo), std::move(dni), std::move(nombre), 15.00, std::move(estrategia), std::move(estado)) {}

double TramiteCartaPracticas::calcularCostoFinal() const {
    return estrategiaTasa_ ? estrategiaTasa_->calcularMonto(tasaBase_) : tasaBase_;
}

TramiteGradoBachiller::TramiteGradoBachiller(std::string codigo,
                                             std::string dni,
                                             std::string nombre,
                                             std::shared_ptr<IEstrategiaTasa> estrategia,
                                             std::string estado)
    : Tramite(std::move(codigo), std::move(dni), std::move(nombre), 180.00, std::move(estrategia), std::move(estado)) {}

double TramiteGradoBachiller::calcularCostoFinal() const {
    double montoBase = estrategiaTasa_ ? estrategiaTasa_->calcularMonto(tasaBase_) : tasaBase_;
    return montoBase + 20.00;
}

TramiteUrgenteDecorator::TramiteUrgenteDecorator(std::shared_ptr<Tramite> tramite)
    : Tramite(tramite->getCodigo(),
              tramite->getDni(),
              tramite->getNombre(),
              tramite->getTasaBase(),
              TramiteFactory::crearEstrategia(tramite->getModalidadTasa()),
              tramite->getEstado()),
      tramiteEnvuelto_(std::move(tramite)) {}

std::string TramiteUrgenteDecorator::obtenerTipo() const {
    return tramiteEnvuelto_->obtenerTipo() + " [URGENTE]";
}

double TramiteUrgenteDecorator::calcularCostoFinal() const {
    return tramiteEnvuelto_->calcularCostoFinal() + RECARGO_URGENCIA;
}

std::string TramiteUrgenteDecorator::serializarCSV() const {
    std::ostringstream oss;
    oss << getCodigo() << ";"
        << tramiteEnvuelto_->obtenerTipo() << ";"
        << getDni() << ";"
        << getNombre() << ";"
        << getModalidadTasa() << ";"
        << "SI;"
        << std::fixed << std::setprecision(2) << calcularCostoFinal() << ";"
        << getEstado();
    return oss.str();
}

std::shared_ptr<IEstrategiaTasa> TramiteFactory::crearEstrategia(const std::string& nombreModalidad) {
    if (nombreModalidad == "Beca 50%") {
        return std::make_shared<EstrategiaTasaBeca>();
    } else if (nombreModalidad == "Exonerado") {
        return std::make_shared<EstrategiaTasaExonerado>();
    }
    return std::make_shared<EstrategiaTasaRegular>();
}

std::shared_ptr<Tramite> TramiteFactory::crearTramite(const std::string& tipo,
                                                      const std::string& codigo,
                                                      const std::string& dni,
                                                      const std::string& nombre,
                                                      const std::string& modalidadTasa,
                                                      bool urgente,
                                                      const std::string& estado) {
    if (codigo.empty()) {
        throw ExcepcionValidacion("El codigo del expediente no puede estar vacio.");
    }
    if (dni.length() != 8 || !std::all_of(dni.begin(), dni.end(), [](unsigned char c) { return std::isdigit(c); })) {
        throw ExcepcionValidacion("El DNI debe contener exactamente 8 digitos numericos.");
    }
    if (nombre.length() < 3) {
        throw ExcepcionValidacion("El nombre del estudiante debe tener al menos 3 caracteres.");
    }

    auto estrategia = crearEstrategia(modalidadTasa);
    std::shared_ptr<Tramite> nuevoTramite;

    if (tipo == "Matricula") {
        nuevoTramite = std::make_shared<TramiteMatricula>(codigo, dni, nombre, estrategia, estado);
    } else if (tipo == "Carta Practicas") {
        nuevoTramite = std::make_shared<TramiteCartaPracticas>(codigo, dni, nombre, estrategia, estado);
    } else if (tipo == "Grado Bachiller") {
        nuevoTramite = std::make_shared<TramiteGradoBachiller>(codigo, dni, nombre, estrategia, estado);
    } else {
        throw ExcepcionValidacion("Tipo de tramite desconocido: " + tipo);
    }

    if (urgente) {
        nuevoTramite = std::make_shared<TramiteUrgenteDecorator>(nuevoTramite);
    }

    return nuevoTramite;
}
