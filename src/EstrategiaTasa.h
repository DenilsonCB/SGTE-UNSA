#ifndef ESTRATEGIATASA_H
#define ESTRATEGIATASA_H

#include <string>
#include <memory>

// Interfaz para el calculo de tasas segun modalidad (Patron Strategy)
class IEstrategiaTasa {
public:
    virtual ~IEstrategiaTasa() = default;
    virtual double calcularMonto(double tasaBase) const = 0;
    virtual std::string obtenerNombreModalidad() const = 0;
};

class EstrategiaTasaRegular : public IEstrategiaTasa {
public:
    double calcularMonto(double tasaBase) const override {
        return tasaBase;
    }
    std::string obtenerNombreModalidad() const override {
        return "Regular";
    }
};

class EstrategiaTasaBeca : public IEstrategiaTasa {
public:
    double calcularMonto(double tasaBase) const override {
        return tasaBase * 0.50;
    }
    std::string obtenerNombreModalidad() const override {
        return "Beca 50%";
    }
};

class EstrategiaTasaExonerado : public IEstrategiaTasa {
public:
    double calcularMonto(double /*tasaBase*/) const override {
        return 0.0;
    }
    std::string obtenerNombreModalidad() const override {
        return "Exonerado";
    }
};

#endif // ESTRATEGIATASA_H
