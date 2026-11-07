# SGTE-UNSA: Sistema de Gestión de Trámites y Expedientes Académicos

Proyecto Final de la asignatura **Tecnología de Objetos (Semestre 2026-B)** — Escuela Profesional de Ingeniería de Sistemas (EPIS), Universidad Nacional de San Agustín de Arequipa (UNSA).

---

## Integrantes del Equipo (Grupo B)
* **Choquehuanca Bedoya, Brayan Denilson**
* **Callo Ccagiavilca, Kevin Joel**
* **Ticona Saure, Jose Maria**

**Docente:** Mg. Roni Guillermo Apaza Aceituno

---

## Descripción General

Aplicación de escritorio desarrollada en **C++17** y **Qt 6 Widgets** para el registro, clasificación polimórfica, liquidación de tasas universitarias y auditoría concurrente de expedientes estudiantiles (*Solicitudes de Matrícula*, *Cartas de Presentación de Prácticas Preprofesionales* y *Carpetas de Grado de Bachiller*).

### Cobertura Temática del Curso
1. **POO, Herencia y Polimorfismo (`src/Tramite.h`, `src/Tramite.cpp`):** Clase base abstracta `Tramite` y subclases concretas `TramiteMatricula`, `TramiteCartaPracticas` y `TramiteGradoBachiller`.
2. **C++ Avanzado y Memoria (`<memory>`):** Punteros inteligentes `std::shared_ptr`, funciones `inline`, métodos `const`, función `friend operator<<` y sobrecarga de `operator<` y `operator==`.
3. **Manejo de Errores (`src/Excepciones.h`):** Jerarquía de excepciones `ExcepcionTramite`, `ExcepcionValidacion` y `ExcepcionPersistencia`.
4. **Programación Genérica y Persistencia (`src/Repositorio.h`):** Plantilla `template <typename T> class Repositorio` sobre `std::vector` con serialización automática en archivo `tramites_unsa.csv`.
5. **Paradigma Funcional y STL:** Expresiones `lambda` combinadas con `std::find_if`, `std::copy_if`, `std::count_if`, `std::accumulate` y `std::sort`.
6. **Multithreading y Objetos Función (`src/HiloProcesador.h`):** Procesamiento en segundo plano mediante `QThread` y el functor `EvaluadorPrioridadFunctor`, actualizando un `QProgressBar` y exportando `reporte_auditoria.txt`.
7. **Patrones de Diseño GoF y MVC:**
   * **Arquitectónico:** Modelo-Vista-Controlador (`ControladorTramites`, `MainWindow`, `Tramite`).
   * **Creacionales:** *Singleton* (`ConfiguracionUNSA`) y *Factory Method* (`TramiteFactory`).
   * **Comportamiento:** *Strategy* (`IEstrategiaTasa`: Regular, Beca 50%, Exonerado).
   * **Estructural:** *Decorator* (`TramiteUrgenteDecorator`).

---

## Estructura del Repositorio

* [`src/`](./src): Código fuente C++17 y archivo de proyecto Qt (`SGTE_UNSA.pro`).
* [`informe/`](./informe): Documento técnico del proyecto (`Informe_Proyecto_Final_SGTE_UNSA.pdf`).
* [`diapositivas/`](./diapositivas): Presentación del proyecto (`Diapositivas_SGTE_UNSA.pdf`).
* [`img/`](./img): Capturas de la interfaz gráfica Qt 6 en ejecución.

---

## Compilación y Ejecución

1. Abrir el archivo `src/SGTE_UNSA.pro` en **Qt Creator** (Kit Desktop Qt 6 MinGW 64-bit) y presionar **Run (`Ctrl + R`)**.
2. O desde terminal con Qt 6 y MinGW en el `PATH`:
   ```bash
   cd src
   qmake SGTE_UNSA.pro
   mingw32-make
   ./release/SGTE_UNSA.exe
   ```
