#ifndef CONTROLADORTRAMITES_H
#define CONTROLADORTRAMITES_H

#include <string>
#include <vector>
#include <memory>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <cctype>
#include "Tramite.h"
#include "Repositorio.h"

class ControladorTramites {
private:
    Repositorio<Tramite> repositorio_;
    int contadorAutogenerado_ = 100;

    static std::string aMinusculas(std::string texto) {
        std::transform(texto.begin(), texto.end(), texto.begin(),
                       [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
        return texto;
    }

public:
    ControladorTramites() {
        cargarDatosIniciales();
    }

    std::string generarSiguienteCodigo() {
        ++contadorAutogenerado_;
        return "EXP-" + std::to_string(contadorAutogenerado_);
    }

    void registrarTramite(const std::string& codigo,
                          const std::string& tipo,
                          const std::string& dni,
                          const std::string& nombre,
                          const std::string& modalidadTasa,
                          bool urgente) {
        auto tramite = TramiteFactory::crearTramite(tipo, codigo, dni, nombre, modalidadTasa, urgente);
        repositorio_.agregar(tramite);
        guardarCambios();
    }

    bool cambiarEstado(const std::string& codigo, const std::string& nuevoEstado) {
        auto tramite = repositorio_.buscarPorCodigo(codigo);
        if (!tramite) {
            return false;
        }
        tramite->setEstado(nuevoEstado);
        guardarCambios();
        return true;
    }

    bool eliminarTramite(const std::string& codigo) {
        bool ok = repositorio_.eliminarPorCodigo(codigo);
        if (ok) {
            guardarCambios();
        }
        return ok;
    }

    void ordenarPorPrioridad() {
        repositorio_.ordenarPorPrioridad();
        guardarCambios();
    }

    std::vector<std::shared_ptr<Tramite>> obtenerFiltrados(const std::string& textoBusqueda,
                                                           const std::string& filtroEstado) const {
        std::string query = aMinusculas(textoBusqueda);
        return repositorio_.filtrar([&query, &filtroEstado](const std::shared_ptr<Tramite>& t) {
            bool coincideEstado = (filtroEstado == "Todos") || (t->getEstado() == filtroEstado);
            if (!coincideEstado) {
                return false;
            }
            if (query.empty()) {
                return true;
            }
            return aMinusculas(t->getCodigo()).find(query) != std::string::npos ||
                   aMinusculas(t->getDni()).find(query) != std::string::npos ||
                   aMinusculas(t->getNombre()).find(query) != std::string::npos ||
                   aMinusculas(t->obtenerTipo()).find(query) != std::string::npos;
        });
    }

    const std::vector<std::shared_ptr<Tramite>>& obtenerTodos() const {
        return repositorio_.obtenerTodos();
    }

    int contarTotal() const {
        return static_cast<int>(repositorio_.tamano());
    }

    int contarPendientes() const {
        return repositorio_.contarSegun([](const std::shared_ptr<Tramite>& t) {
            return t->getEstado() == "Pendiente";
        });
    }

    int contarUrgentes() const {
        return repositorio_.contarSegun([](const std::shared_ptr<Tramite>& t) {
            return t->esUrgente();
        });
    }

    double obtenerRecaudacionTotal() const {
        return repositorio_.calcularMontoTotal();
    }

    void guardarCambios() const {
        repositorio_.guardarEnCSV(ConfiguracionUNSA::instancia().getRutaArchivo());
    }

    void cargarDatosIniciales() {
        const std::string& ruta = ConfiguracionUNSA::instancia().getRutaArchivo();
        std::ifstream archivo(ruta);
        if (archivo.is_open()) {
            std::string linea;
            std::getline(archivo, linea);
            while (std::getline(archivo, linea)) {
                if (linea.empty()) continue;
                std::stringstream ss(linea);
                std::string codigo, tipo, dni, nombre, modalidad, urgStr, costoStr, estado;
                std::getline(ss, codigo, ';');
                std::getline(ss, tipo, ';');
                std::getline(ss, dni, ';');
                std::getline(ss, nombre, ';');
                std::getline(ss, modalidad, ';');
                std::getline(ss, urgStr, ';');
                std::getline(ss, costoStr, ';');
                std::getline(ss, estado, ';');
                try {
                    auto t = TramiteFactory::crearTramite(tipo, codigo, dni, nombre, modalidad, urgStr == "SI", estado);
                    repositorio_.agregar(t);
                    ++contadorAutogenerado_;
                } catch (...) {
                }
            }
            archivo.close();
        }

        if (repositorio_.tamano() == 0) {
            repositorio_.agregar(TramiteFactory::crearTramite(
                "Grado Bachiller", generarSiguienteCodigo(), "72849103",
                "Choquehuanca Bedoya Brayan", "Beca 50%", true, "En Revision"));
            repositorio_.agregar(TramiteFactory::crearTramite(
                "Carta Practicas", generarSiguienteCodigo(), "74102938",
                "Callo Ccagiavilca Kevin", "Regular", false, "Pendiente"));
            repositorio_.agregar(TramiteFactory::crearTramite(
                "Matricula", generarSiguienteCodigo(), "71928374",
                "Ticona Saure Jose Maria", "Exonerado", false, "Atendido"));
            repositorio_.agregar(TramiteFactory::crearTramite(
                "Grado Bachiller", generarSiguienteCodigo(), "75647382",
                "Zeballos Paredes Luis", "Regular", false, "Pendiente"));
            repositorio_.agregar(TramiteFactory::crearTramite(
                "Carta Practicas", generarSiguienteCodigo(), "76019283",
                "Flores Condori Camila", "Beca 50%", true, "Pendiente"));
            guardarCambios();
        }
    }
};

#endif // CONTROLADORTRAMITES_H
