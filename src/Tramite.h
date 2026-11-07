#ifndef TRAMITE_H
#define TRAMITE_H

#include <string>
#include <memory>
#include <iostream>
#include <sstream>
#include <iomanip>
#include "EstrategiaTasa.h"
#include "Excepciones.h"

// Configuracion global del sistema (Singleton)
class ConfiguracionUNSA {
private:
    std::string semestreActivo_;
    std::string rutaArchivoPorDefecto_;

    ConfiguracionUNSA()
        : semestreActivo_("2026-B"), rutaArchivoPorDefecto_("tramites_unsa.csv") {}

public:
    ConfiguracionUNSA(const ConfiguracionUNSA&) = delete;
    ConfiguracionUNSA& operator=(const ConfiguracionUNSA&) = delete;

    static ConfiguracionUNSA& instancia() {
        static ConfiguracionUNSA unicaInstancia;
        return unicaInstancia;
    }

    inline const std::string& getSemestreActivo() const { return semestreActivo_; }
    inline const std::string& getRutaArchivo() const { return rutaArchivoPorDefecto_; }
};

// Clase base abstracta para los expedientes academicos
class Tramite {
protected:
    std::string codigo_;
    std::string dniEstudiante_;
    std::string nombreEstudiante_;
    std::string estado_;
    double tasaBase_;
    std::shared_ptr<IEstrategiaTasa> estrategiaTasa_;

public:
    Tramite(std::string codigo,
            std::string dni,
            std::string nombre,
            double tasaBase,
            std::shared_ptr<IEstrategiaTasa> estrategia,
            std::string estado = "Pendiente");

    virtual ~Tramite() = default;

    virtual std::string obtenerTipo() const = 0;
    virtual double calcularCostoFinal() const = 0;
    virtual int obtenerPrioridad() const = 0; // 0 = Urgente, 1 = Alta, 2 = Media, 3 = Normal
    virtual bool esUrgente() const { return false; }

    inline const std::string& getCodigo() const { return codigo_; }
    inline const std::string& getDni() const { return dniEstudiante_; }
    inline const std::string& getNombre() const { return nombreEstudiante_; }
    inline const std::string& getEstado() const { return estado_; }
    inline double getTasaBase() const { return tasaBase_; }
    inline std::string getModalidadTasa() const {
        return estrategiaTasa_ ? estrategiaTasa_->obtenerNombreModalidad() : "Regular";
    }

    void setEstado(const std::string& nuevoEstado) { estado_ = nuevoEstado; }
    void setEstrategiaTasa(std::shared_ptr<IEstrategiaTasa> nuevaEstrategia) {
        estrategiaTasa_ = std::move(nuevaEstrategia);
    }

    virtual std::string serializarCSV() const;

    bool operator<(const Tramite& otro) const {
        if (this->obtenerPrioridad() != otro.obtenerPrioridad()) {
            return this->obtenerPrioridad() < otro.obtenerPrioridad();
        }
        return this->codigo_ < otro.codigo_;
    }

    bool operator==(const Tramite& otro) const {
        return this->codigo_ == otro.codigo_;
    }

    friend std::ostream& operator<<(std::ostream& os, const Tramite& t);
};

class TramiteMatricula : public Tramite {
public:
    TramiteMatricula(std::string codigo,
                     std::string dni,
                     std::string nombre,
                     std::shared_ptr<IEstrategiaTasa> estrategia,
                     std::string estado = "Pendiente");

    std::string obtenerTipo() const override { return "Matricula"; }
    double calcularCostoFinal() const override;
    int obtenerPrioridad() const override { return 2; }
};

class TramiteCartaPracticas : public Tramite {
public:
    TramiteCartaPracticas(std::string codigo,
                          std::string dni,
                          std::string nombre,
                          std::shared_ptr<IEstrategiaTasa> estrategia,
                          std::string estado = "Pendiente");

    std::string obtenerTipo() const override { return "Carta Practicas"; }
    double calcularCostoFinal() const override;
    int obtenerPrioridad() const override { return 3; }
};

class TramiteGradoBachiller : public Tramite {
public:
    TramiteGradoBachiller(std::string codigo,
                          std::string dni,
                          std::string nombre,
                          std::shared_ptr<IEstrategiaTasa> estrategia,
                          std::string estado = "Pendiente");

    std::string obtenerTipo() const override { return "Grado Bachiller"; }
    double calcularCostoFinal() const override;
    int obtenerPrioridad() const override { return 1; }
};

// Decorador para tramites con atencion urgente
class TramiteUrgenteDecorator : public Tramite {
private:
    std::shared_ptr<Tramite> tramiteEnvuelto_;
    static constexpr double RECARGO_URGENCIA = 20.0;

public:
    explicit TramiteUrgenteDecorator(std::shared_ptr<Tramite> tramite);

    std::string obtenerTipo() const override;
    double calcularCostoFinal() const override;
    int obtenerPrioridad() const override { return 0; }
    bool esUrgente() const override { return true; }
    std::string serializarCSV() const override;
};

// Fabrica para instanciar tramites y estrategias desde el formulario
class TramiteFactory {
public:
    static std::shared_ptr<IEstrategiaTasa> crearEstrategia(const std::string& nombreModalidad);

    static std::shared_ptr<Tramite> crearTramite(const std::string& tipo,
                                                 const std::string& codigo,
                                                 const std::string& dni,
                                                 const std::string& nombre,
                                                 const std::string& modalidadTasa,
                                                 bool urgente = false,
                                                 const std::string& estado = "Pendiente");
};

#endif // TRAMITE_H
