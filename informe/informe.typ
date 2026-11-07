#let granate-unsa = rgb("#7a1315")
#let gris-borde = rgb("#cbd5e1")
#let gris-linea = rgb("#64748b")

#set document(
  title: "SGTE-UNSA: Sistema de Gestión de Trámites y Expedientes Académicos",
  author: (
    "Brayan Denilson Choquehuanca Bedoya",
    "Kevin Joel Callo Ccagiavilca",
    "Jose Maria Ticona Saure",
  ),
)

#set text(
  font: ("Calibri", "Arial"),
  size: 10.5pt,
  fill: rgb("#000000"),
  lang: "es",
)

#set par(
  justify: true,
  leading: 0.68em,
  spacing: 1.1em,
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.2cm, left: 2.2cm, right: 2.2cm),
  header: context {
    if counter(page).get().first() > 1 [
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(size: 8.5pt, fill: gris-linea)[
          *UNSA · EPIS* | Tecnología de Objetos (2026-B)
        ],
        text(size: 8.5pt, fill: granate-unsa, weight: "bold")[
          Proyecto Final: SGTE-UNSA
        ],
      )
      #v(-0.22cm)
      #line(length: 100%, stroke: 0.6pt + gris-borde)
    ]
  },
  footer: context {
    if counter(page).get().first() > 1 [
      #line(length: 100%, stroke: 0.6pt + gris-borde)
      #v(0.12cm)
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(size: 8.5pt, fill: gris-linea)[
          Sistema de Gestión de Trámites y Expedientes Académicos · Semestre 2026-B
        ],
        text(size: 8.8pt, fill: rgb("#000000"), weight: "bold")[
          #counter(page).display("1 / 1", both: true)
        ],
      )
    ]
  },
)

#show heading: it => {
  set text(font: ("Calibri", "Arial"), fill: rgb("#000000"), weight: "bold")
  if it.level == 1 {
    v(0.65em, weak: true)
    block(below: 0.55em)[
      #text(size: 13.5pt)[#it.body]
    ]
  } else if it.level == 2 {
    v(0.5em, weak: true)
    block(below: 0.4em)[
      #text(size: 11.5pt)[#it.body]
    ]
  } else {
    v(0.4em, weak: true)
    block(below: 0.3em)[
      #text(size: 10.5pt)[#it.body]
    ]
  }
}

#let codigo_fuente(ruta_y_rango, inicio_linea, bloque_raw) = {
  block(
    width: 100%,
    fill: none,
    stroke: 0.5pt + gris-borde,
    radius: 3pt,
    inset: 9pt,
    breakable: true,
  )[
    #text(size: 8pt, font: "Consolas", fill: gris-linea)[\/\/ #ruta_y_rango]
    #v(3pt)
    #show raw.line: it => {
      box(width: 2.2em)[
        #align(right)[
          #text(fill: gris-linea, size: 7.8pt)[#(it.number + inicio_linea - 1)]
        ]
      ]
      h(0.8em)
      it.body
    }
    #set text(font: "Consolas", size: 8.2pt)
    #bloque_raw
  ]
}

// ================= PORTADA OFICIAL INDEPENDIENTE =================
#align(center)[
  #v(0.3cm)
  #text(weight: "bold", size: 13.5pt, fill: rgb("#000000"))[
    UNIVERSIDAD NACIONAL DE SAN AGUSTÍN DE AREQUIPA
  ] \
  #v(0.15cm)
  #text(weight: "bold", size: 11.5pt, fill: rgb("#000000"))[
    FACULTAD DE INGENIERÍA DE PRODUCCIÓN Y SERVICIOS
  ] \
  #v(0.12cm)
  #text(weight: "bold", size: 11pt, fill: rgb("#000000"))[
    ESCUELA PROFESIONAL DE INGENIERÍA DE SISTEMAS
  ]

  #v(0.9cm)
  #image("../img/escudo_unsa.png", width: 4.5cm)
  #v(0.9cm)

  #text(weight: "bold", size: 11pt, fill: rgb("#000000"))[
    TRABAJO DE INVESTIGACIÓN FORMATIVA · PROYECTO FINAL
  ] \
  #v(0.25cm)
  #set par(justify: false)
  #text(weight: "bold", size: 16pt, fill: rgb("#000000"))[
    SGTE-UNSA: SISTEMA DE GESTIÓN DE TRÁMITES Y \
    EXPEDIENTES ACADÉMICOS EN C++17 Y QT WIDGETS
  ] \
  #v(0.2cm)
  #text(size: 10.5pt, style: "italic", fill: rgb("#000000"))[
    Aplicación de Programación Orientada a Objetos, Patrones GoF, STL y Multithreading
  ]
]

#v(2.0cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  align: (left + top, left + top),
  [
    #text(weight: "bold", size: 10.5pt)[Datos Académicos:]
    #v(0.2cm)
    *Asignatura:* Tecnología de Objetos \
    *Código:* 1703240 · VI Ciclo · 2026-B \
    *Grupo de Teoría:* TEO B \
    *Docente:* Mg. Roni Guillermo Apaza Aceituno \
    *Repositorio:* #link("https://github.com/DenilsonCB/SGTE-UNSA")[`github.com/DenilsonCB/SGTE-UNSA`]
  ],
  [
    #text(weight: "bold", size: 10.5pt)[Integrantes del Equipo:]
    #v(0.2cm)
    - Choquehuanca Bedoya, Brayan Denilson
    - Callo Ccagiavilca, Kevin Joel
    - Ticona Saure, Jose Maria
  ]
)

#v(1fr)
#align(center)[
  #text(weight: "bold", size: 10.5pt)[Arequipa – Perú] \
  #text(size: 10pt)[2026]
]

#pagebreak()

// ================= SECCIÓN 1: INTRODUCCIÓN =================
= 1. Introducción

La gestión de trámites administrativos estudiantiles en una escuela profesional involucra diferentes tipos de expedientes, reglas diferenciadas para el cálculo de tasas universitarias, niveles variables de prioridad y requisitos de trazabilidad documental. Cuando estos sistemas se construyen de manera procedimental o acoplando las reglas de cálculo dentro de los formularios de interfaz gráfica, el mantenimiento se vuelve costoso ante cualquier cambio normativo en el tarifario institucional.

El proyecto *SGTE-UNSA (Sistema de Gestión de Trámites y Expedientes Académicos)* resuelve esta problemática mediante una aplicación de escritorio desarrollada en C++17 y el framework Qt 6 Widgets. Su propósito académico consiste en integrar de forma cohesiva y verificable los principios de la asignatura Tecnología de Objetos: encapsulación, herencia, polimorfismo dinámico, punteros inteligentes, sobrecarga de operadores, manejo de excepciones, programación genérica con plantillas, algoritmos de la librería estándar STL con expresiones lambda, patrones de diseño GoF bajo arquitectura Modelo-Vista-Controlador (MVC) y ejecución concurrente mediante hilos de trabajo.

Como se detalla en la @tab-silabo, cada módulo del código fuente ha sido proyectado para cubrir los ejes temáticos establecidos en el sílabo del curso.

#figure(
  table(
    columns: (1.35fr, 1.15fr, 2.3fr),
    inset: 7pt,
    align: (left + top, left + top, left + top),
    stroke: 0.5pt + gris-borde,
    fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else { none },
    [*Unidad / Tema del Sílabo*], [*Archivo del Proyecto*], [*Aplicación Concreta en SGTE-UNSA*],
    [POO, Herencia, Polimorfismo y `const` / `inline` / `friend`],
    [`src/Tramite.h` \ `src/Tramite.cpp`],
    [Clase base abstracta `Tramite` con subclases `TramiteMatricula`, `TramiteCartaPracticas` y `TramiteGradoBachiller`, además de sobrecarga de `operator<` y `operator==`.],

    [Punteros Inteligentes y Memoria STL],
    [`src/Tramite.cpp` \ `src/Repositorio.h`],
    [Gestión automática del ciclo de vida de expedientes y estrategias mediante `std::shared_ptr<Tramite>` y `std::make_shared`.],

    [Manejo de Errores y Excepciones],
    [`src/Excepciones.h`],
    [Jerarquía `ExcepcionTramite`, `ExcepcionValidacion` y `ExcepcionPersistencia` derivada de `std::runtime_error`.],

    [Programación Genérica y Persistencia],
    [`src/Repositorio.h`],
    [Clase plantilla `Repositorio<T>` respaldada por `std::vector` y serialización hacia el archivo plano `tramites_unsa.csv`.],

    [Expresiones Lambda y Algoritmos STL],
    [`src/Repositorio.h` \ `src/MainWindow.cpp`],
    [Consultas declarativas con `std::find_if`, `std::copy_if`, `std::count_if`, `std::accumulate`, `std::sort` y slots reactivos en Qt.],

    [Multithreading y Objetos Función],
    [`src/HiloProcesador.h`],
    [Clase `HiloProcesador` derivada de `QThread` y functor `EvaluadorPrioridadFunctor` para auditar expedientes en segundo plano.],

    [Patrones de Diseño GoF y MVC],
    [`src/Controlador-` \ `Tramites.h` \ `src/EstrategiaTasa.h`],
    [Arquitectura MVC combinada con *Singleton*, *Factory Method*, *Strategy* y *Decorator*.],
  ),
  caption: [Trazabilidad entre los temas del sílabo de Tecnología de Objetos y los módulos de SGTE-UNSA.],
) <tab-silabo>

La distribución mostrada en la @tab-silabo permite aislar las responsabilidades técnicas dentro del proyecto: las entidades del dominio permanecen libres de dependencias gráficas de Qt, facilitando su lectura, prueba y extensión.

// ================= SECCIÓN 2: MARCO TEÓRICO =================
= 2. Marco teórico

== 2.1 Polimorfismo dinámico, principios SOLID y gestión automática de memoria
El polimorfismo de subtipado permite que una referencia o puntero a una clase base abstracta invoque métodos sobrescritos (`override`) en sus clases derivadas mediante enlace dinámico (*dynamic binding*). Para cumplir con el Principio Abierto/Cerrado (OCP) de SOLID, las entidades deben estar abiertas para su extensión pero cerradas para su modificación directa. En C++ moderno, el uso de punteros inteligentes (`std::unique_ptr` y `std::shared_ptr`) de la cabecera `<memory>` automatiza la liberación determinista de recursos bajo el idioma RAII (*Resource Acquisition Is Initialization*), previniendo fugas de memoria al almacenar jerarquías polimórficas en contenedores estándar.

== 2.2 Programación genérica, contenedores STL frente a Qt y expresiones lambda
Las plantillas de clase (`template <typename T>`) habilitan el polimorfismo paramétrico en tiempo de compilación, permitiendo escribir estructuras de datos y repositorios independientes del tipo almacenado. En el desarrollo con C++ y Qt resulta fundamental contrastar y justificar la elección entre los contenedores de la librería estándar (`std::vector`) y los contenedores secuenciales de Qt (`QVector` y `QList`). En Qt 6, `QVector<T>` es un alias directo de `QList<T>`, el cual almacena sus elementos en un bloque contiguo de memoria con semántica *copy-on-write* (compartición implícita mediante conteo atómico de referencias) optimizada para el intercambio de datos con widgets gráficos. Por el contrario, `std::vector<T>` carece de sobrecarga por conteo atómico de copia y mantiene la capa de dominio 100% independiente del framework gráfico. Por esta razón, en SGTE-UNSA se seleccionó `std::vector<std::shared_ptr<T>>` dentro del modelo genérico `Repositorio<T>` y se reservaron las estructuras de Qt (`QStringList`, `QTableWidgetItem`) exclusivamente para la capa de vista (`MainWindow`).

Cuando las colecciones de la STL se procesan mediante algoritmos de `<algorithm>` y `<numeric>` (`std::find_if`, `std::copy_if`, `std::count_if`, `std::for_each`, `std::transform`, `std::accumulate` y `std::sort`) combinados con expresiones lambda (`[captura](parametros) { cuerpo }`), el compilador genera objetos clausura en línea que operan sin sobrecarga de indirección y mejoran la legibilidad frente a los bucles imperativos.

== 2.3 Patrones de diseño GoF y concurrencia en interfaces gráficas
Los patrones catalogados por Gamma et al. (GoF) se dividen en creacionales, estructurales y de comportamiento. Dentro de una aplicación con interfaz gráfica estructurada bajo el patrón Modelo-Vista-Controlador (MVC), la ejecución de tareas intensivas de entrada/salida sobre el hilo principal bloquea el bucle de eventos (*event loop*). El uso de hilos de trabajo (`QThread`) comunicados mediante señales asíncronas garantiza que la ventana mantenga su capacidad de respuesta mientras se procesan lotes de datos en segundo plano.

// ================= SECCIÓN 3: DISEÑO ARQUITECTÓNICO =================
= 3. Diseño arquitectónico y patrones GoF

El sistema se organiza bajo el patrón arquitectónico MVC e incorpora cuatro patrones GoF seleccionados para resolver problemas específicos del dominio de trámites universitarios. Como se resume en la @tab-patrones, se implementó al menos un representante de cada familia de patrones GoF.

#figure(
  table(
    columns: (1fr, 1.1fr, 1.3fr, 2.3fr),
    inset: 7pt,
    align: (left + top, left + top, left + top, left + top),
    stroke: 0.5pt + gris-borde,
    fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else { none },
    [*Categoría*], [*Patrón*], [*Clases Participantes*], [*Justificación Técnica en el Dominio*],
    [Arquitectónico],
    [MVC],
    [`Tramite` \ `MainWindow` \ `ControladorTramites`],
    [Desacopla la ventana Qt de la lógica de validación, cálculo de tasas y persistencia en disco.],

    [Creacional],
    [Singleton],
    [`ConfiguracionUNSA`],
    [Centraliza en una instancia única el semestre académico activo (`2026-B`) y la ruta del archivo CSV.],

    [Creacional],
    [Factory Method],
    [`TramiteFactory`],
    [Encapsula la validación e instanciación polimórfica de trámites y estrategias a partir de cadenas de la GUI.],

    [Comportamiento],
    [Strategy],
    [`IEstrategiaTasa` \ y 3 subclases],
    [Permite intercambiar el algoritmo de liquidación de tasas (*Regular*, *Beca 50%* y *Exonerado*) en tiempo de ejecución.],

    [Estructural],
    [Decorator],
    [`TramiteUrgente-` \ `Decorator`],
    [Añade atención prioritaria (`Prioridad 0`) y recargo de urgencia (`+S/ 20.00`) envolviendo cualquier trámite existente.],
  ),
  caption: [Patrones de diseño implementados en la arquitectura de SGTE-UNSA.],
) <tab-patrones>

A partir de la estructura definida en la @tab-patrones, la interacción entre el decorador estructural y las estrategias de comportamiento evita la explosión combinatoria de subclases: en lugar de codificar nueve clases distintas para combinar tres tipos de trámite con tres modalidades de tasa y urgencia, el diseño resuelve todas las combinaciones con tres subclases de `Tramite`, tres estrategias y un decorador.

En la @fig-uml se representa el diagrama de clases UML generado con PlantUML mostrando las relaciones entre los paquetes de Vista, Controlador y Modelo del sistema SGTE-UNSA.

#figure(
  image("../img/diagrama_uml_sgte.png", width: 100%),
  caption: [Diagrama de clases UML de la arquitectura MVC, jerarquía polimórfica de `Tramite` y patrones GoF.],
) <fig-uml>

Como se aprecia en la @fig-uml, la clase abstracta `Tramite` mantiene una relación de agregación polimórfica con la interfaz `IEstrategiaTasa` y es extendida tanto por las tres subclases de dominio como por el decorador `TramiteUrgenteDecorator`, mientras que `MainWindow` se comunica con `ControladorTramites` y lanza el hilo `HiloProcesador`.

// ================= SECCIÓN 4: IMPLEMENTACIÓN =================
= 4. Implementación

== 4.1 Jerarquía polimórfica, sobrecarga de operadores y patrones en `Tramite.h`
La clase base abstracta `Tramite` encapsula los atributos comunes del expediente y define la interfaz polimórfica junto con la sobrecarga de los operadores relacionales `operator<` y `operator==`. A continuación se presenta el fragmento correspondiente de `src/Tramite.h` (líneas 35 a 87).

#codigo_fuente("src/Tramite.h (Líneas 35–87)", 35, ```cpp
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
```)

En el bloque anterior se observa que `operator<` compara en primera instancia el resultado polimórfico de `obtenerPrioridad()`, donde `0` representa prioridad urgente y `3` prioridad normal, utilizando el código lexicográfico como criterio de desempate. Por su parte, la declaración `friend std::ostream& operator<<` permite exportar el expediente formateado directamente hacia flujos de archivo durante la auditoría.

== 4.2 Repositorio genérico, algoritmos STL y funciones lambda en `Repositorio.h`
Para desacoplar el almacenamiento respecto al tipo de entidad, se implementó la plantilla `Repositorio<T>` en `src/Repositorio.h`. El siguiente fragmento (líneas 52 a 101) muestra la integración de plantillas de método con predicados lambda y algoritmos de la STL.

#codigo_fuente("src/Repositorio.h (Líneas 52–101)", 52, ```cpp
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
```)

El diseño de `Repositorio<T>` evita exponer los iteradores internos de `std::vector<std::shared_ptr<T>>`. En su lugar, expone operaciones funcionales de alto nivel: `filtrar` emplea `std::copy_if` con `std::back_inserter`, `contarSegun` envuelve `std::count_if`, `calcularMontoTotal` reduce la colección mediante `std::accumulate` y `guardarEnCSV` recorre los elementos con `std::for_each` capturando el flujo de archivo por referencia (`[&archivo]`).

== 4.3 Procesamiento concurrente con `QThread` y objeto función en `HiloProcesador.h`
El módulo de concurrencia emplea un objeto función (*functor*) y una subclase de `QThread` para auditar la lista de expedientes y generar un archivo de liquidación en disco sin bloquear el hilo de interfaz gráfica. A continuación se muestra la implementación en `src/HiloProcesador.h` (líneas 12 a 73).

#codigo_fuente("src/HiloProcesador.h (Líneas 12–73)", 12, ```cpp
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
```)

Para evitar condiciones de carrera sobre el vector de la interfaz principal, el constructor de `HiloProcesador` recibe por valor una copia ligera del vector de `std::shared_ptr<Tramite>`. Durante la ejecución de `run()`, el hilo secundario invoca el operador sobrecargado `operator()` de `EvaluadorPrioridadFunctor` y notifica el avance a la ventana principal mediante la señal `progresoActualizado`, la cual es encolada de forma segura por el sistema de meta-objetos de Qt.

// ================= SECCIÓN 5: EJECUCIÓN DEL CÓDIGO Y RESULTADOS =================
= 5. Ejecución del código y explicación de resultados

El proyecto fue compilado utilizando el estándar C++17 con el compilador MinGW 13.1 de 64 bits y Qt 6.12.0 bajo las banderas `-Wall -Wextra`. En la @fig-general se observa la ventana principal de *SGTE-UNSA* tras cargar los expedientes iniciales desde el archivo `tramites_unsa.csv`.

#figure(
  image("../img/vista_general_sgte.png", width: 95%),
  caption: [Interfaz gráfica principal de SGTE-UNSA mostrando el registro polimórfico, el filtrado funcional y las métricas calculadas con algoritmos STL.],
) <fig-general>

En la @fig-general se comprueba el cálculo polimórfico de tasas y la aplicación de los patrones *Strategy* y *Decorator*:
- El expediente `EXP-101` (*Grado Bachiller*, tasa base S/ 180.00 + S/ 20.00 de diploma) bajo modalidad *Beca 50%* reduce su base a S/ 90.00 (+ S/ 20.00 = S/ 110.00) y, al estar envuelto por `TramiteUrgenteDecorator`, suma S/ 20.00 adicionales alcanzando un costo final de `S/ 130.00` con prioridad `0 - URGENTE`.
- El expediente `EXP-103` (*Matrícula*) con estrategia *Exonerado* registra un costo final de `S/ 0.00`.
- En la barra inferior de métricas se comprueba que `std::count_if` identifica 3 expedientes pendientes y 2 urgentes, mientras que `std::accumulate` totaliza `S/ 372.50`.

Posteriormente se ejecutó el ordenamiento polimórfico mediante `std::sort` y el hilo de auditoría. La @fig-auditoria presenta el estado de la interfaz tras ordenar los expedientes por nivel de prioridad (`0 - URGENTE`, `1 - Alta`, `2 - Media`, `3 - Normal`) y completar al 100% la auditoría concurrente con `QThread`.

#figure(
  image("../img/auditoria_multihilo_sgte.png", width: 95%),
  caption: [Ordenamiento por `operator<` y culminación de la auditoría en segundo plano mediante `QThread` y `EvaluadorPrioridadFunctor`.],
) <fig-auditoria>

Como muestra la @fig-auditoria, los dos expedientes decorados como urgentes (`EXP-101` y `EXP-105`) se posicionan en las primeras filas de la tabla gracias a la sobrecarga de `operator<`, seguidos por el trámite de *Grado Bachiller* (`1 - Alta`), *Matrícula* (`2 - Media`) y *Carta Prácticas* (`3 - Normal`). Asimismo, la barra `QProgressBar` alcanza el `100%` y reporta la generación del archivo `reporte_auditoria.txt` con 3 alertas de prioridad alta o urgente pendientes de atención.

// ================= SECCIÓN 6: CONCLUSIONES =================
= 6. Conclusiones

El desarrollo del sistema SGTE-UNSA permitió integrar los pilares de la programación orientada a objetos y los paradigmas modernos de C++17 dentro de una arquitectura modular Modelo-Vista-Controlador en Qt 6. La definición de la clase abstracta `Tramite` y sus tres subclases demostró cómo el polimorfismo dinámico y el uso de punteros inteligentes `std::shared_ptr` simplifican el manejo de colecciones heterogéneas sin fugas de memoria.

La incorporación conjunta de los patrones creacionales (Singleton y Factory Method), de comportamiento (Strategy) y estructurales (Decorator) permitió desacoplar la creación de objetos y el cálculo de tasas universitarias respecto a la interfaz gráfica. En particular, la combinación de `IEstrategiaTasa` con `TramiteUrgenteDecorator` evitó duplicar clases para representar becas, exoneraciones y recargos de urgencia, satisfaciendo el principio Abierto/Cerrado.

Finalmente, la implementación de la plantilla `Repositorio<T>` apoyada en expresiones lambda, algoritmos de la librería estándar STL (`std::find_if`, `std::copy_if`, `std::count_if`, `std::accumulate`, `std::sort`) y un hilo secundario basado en `QThread` y objetos función demostró que la combinación de programación genérica, funcional y concurrente produce código conciso, expresivo y capaz de ejecutar operaciones de entrada/salida en segundo plano sin degradar la experiencia interactiva del usuario.

#pagebreak()

// ================= SECCIÓN 7: REFERENCIAS BIBLIOGRÁFICAS =================
= 7. Referencias bibliográficas

+ B. Stroustrup, _The C++ Programming Language_, 4th ed. Boston, MA, USA: Addison-Wesley, 2013.

+ E. Gamma, R. Helm, R. Johnson, and J. Vlissides, _Design Patterns: Elements of Reusable Object-Oriented Software_. Reading, MA, USA: Addison-Wesley, 1995.

+ J. Bloch, _Effective Java_, 3rd ed. Boston, MA, USA: Addison-Wesley Professional, 2017.

+ B. Meyer, "Applying 'design by contract'," _Computer_, vol. 25, no. 10, pp. 40–51, Oct. 1992.

+ The Qt Company, _Qt 6.12 Documentation: Qt Widgets and QThread Reference_, 2026. [Online]. Available: https://doc.qt.io/qt-6/
