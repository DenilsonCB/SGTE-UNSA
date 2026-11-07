#ifndef EXCEPCIONES_H
#define EXCEPCIONES_H

#include <stdexcept>
#include <string>

class ExcepcionTramite : public std::runtime_error {
public:
    explicit ExcepcionTramite(const std::string& mensaje)
        : std::runtime_error(mensaje) {}
};

class ExcepcionValidacion : public ExcepcionTramite {
public:
    explicit ExcepcionValidacion(const std::string& detalle)
        : ExcepcionTramite("Error de validacion en expediente: " + detalle) {}
};

class ExcepcionPersistencia : public ExcepcionTramite {
public:
    explicit ExcepcionPersistencia(const std::string& archivo)
        : ExcepcionTramite("No se pudo acceder al archivo de persistencia: " + archivo) {}
};

#endif // EXCEPCIONES_H
