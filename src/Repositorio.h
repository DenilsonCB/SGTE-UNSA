#ifndef REPOSITORIO_H
#define REPOSITORIO_H

#include <vector>
#include <memory>
#include <string>
#include <algorithm>
#include <numeric>
#include <fstream>
#include <sstream>
#include "Excepciones.h"

template <typename T>
class Repositorio {
private:
    std::vector<std::shared_ptr<T>> elementos_;

public:
    Repositorio() = default;

    void agregar(std::shared_ptr<T> item) {
        auto it = std::find_if(elementos_.begin(), elementos_.end(),
                               [&item](const std::shared_ptr<T>& actual) {
                                   return *actual == *item;
                               });
        if (it != elementos_.end()) {
            throw ExcepcionValidacion("Ya existe un expediente registrado con el codigo " + item->getCodigo());
        }
        elementos_.push_back(std::move(item));
    }

    bool eliminarPorCodigo(const std::string& codigo) {
        auto it = std::remove_if(elementos_.begin(), elementos_.end(),
                                 [&codigo](const std::shared_ptr<T>& item) {
                                     return item->getCodigo() == codigo;
                                 });
        if (it != elementos_.end()) {
            elementos_.erase(it, elementos_.end());
            return true;
        }
        return false;
    }

    std::shared_ptr<T> buscarPorCodigo(const std::string& codigo) const {
        auto it = std::find_if(elementos_.begin(), elementos_.end(),
                               [&codigo](const std::shared_ptr<T>& item) {
                                   return item->getCodigo() == codigo;
                               });
        return (it != elementos_.end()) ? *it : nullptr;
    }

    template <typename Predicado>
    std::vector<std::shared_ptr<T>> filtrar(Predicado pred) const {
        std::vector<std::shared_ptr<T>> resultado;
        std::copy_if(elementos_.begin(), elementos_.end(), std::back_inserter(resultado), pred);
        return resultado;
    }

    template <typename Predicado>
    int contarSegun(Predicado pred) const {
        return static_cast<int>(std::count_if(elementos_.begin(), elementos_.end(), pred));
    }

    double calcularMontoTotal() const {
        return std::accumulate(elementos_.begin(), elementos_.end(), 0.0,
                               [](double acumulado, const std::shared_ptr<T>& item) {
                                   return acumulado + item->calcularCostoFinal();
                               });
    }

    void ordenarPorPrioridad() {
        std::sort(elementos_.begin(), elementos_.end(),
                  [](const std::shared_ptr<T>& a, const std::shared_ptr<T>& b) {
                      return *a < *b;
                  });
    }

    const std::vector<std::shared_ptr<T>>& obtenerTodos() const {
        return elementos_;
    }

    std::size_t tamano() const {
        return elementos_.size();
    }

    void limpiar() {
        elementos_.clear();
    }

    void guardarEnCSV(const std::string& rutaArchivo) const {
        std::ofstream archivo(rutaArchivo, std::ios::out | std::ios::trunc);
        if (!archivo.is_open()) {
            throw ExcepcionPersistencia(rutaArchivo);
        }
        archivo << "CODIGO;TIPO;DNI;ESTUDIANTE;MODALIDAD;URGENTE;COSTO_FINAL;ESTADO\n";
        std::for_each(elementos_.begin(), elementos_.end(),
                      [&archivo](const std::shared_ptr<T>& item) {
                          archivo << item->serializarCSV() << "\n";
                      });
    }
};

#endif // REPOSITORIO_H
