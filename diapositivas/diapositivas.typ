#let granate = rgb("#7a1315")
#let granate-dark = rgb("#560d0f")
#let azul-oscuro = rgb("#0f172a")
#let gris-claro = rgb("#f8fafc")
#let fondo-card = rgb("#fbf2f2")
#let gris-borde = rgb("#cbd5e1")
#let gris-texto = rgb("#64748b")

#set page(
  paper: "presentation-16-9",
  margin: (x: 1.5cm, top: 1.2cm, bottom: 1.1cm),
  background: place(
    center + horizon,
    rect(
      width: 97.2%,
      height: 94.6%,
      stroke: 1.6pt + granate,
      radius: 6pt,
    ),
  ),
  footer: context {
    let p = counter(page).get().first()
    let total = counter(page).final().first()
    grid(
      columns: (1fr, auto),
      align: (left, right),
      text(size: 8.8pt, fill: gris-texto)[
        #if p == 1 [
          Arequipa · Semestre 2026-B
        ] else [
          TECNOLOGÍA DE OBJETOS (GRUPO B) · Mg. Roni Guillermo Apaza Aceituno
        ]
      ],
      text(size: 9pt, fill: granate, weight: "bold")[#p / #total],
    )
  },
)

#set text(
  font: ("Calibri", "Arial"),
  size: 13.5pt,
  fill: azul-oscuro,
  lang: "es",
)

#let titulo_lamina(bloque, titulo) = {
  grid(
    columns: (1fr, 3.1cm),
    gutter: 0.6cm,
    align: (left + horizon, right + horizon),
    rect(
      fill: granate,
      radius: 4pt,
      inset: (x: 12pt, y: 7pt),
      width: 100%,
      text(fill: white, size: 16.5pt, weight: "bold")[#titulo],
    ),
    image("../img/unsa_logo.png", width: 2.9cm),
  )
  v(-0.15cm)
  text(size: 9.2pt, fill: gris-texto, weight: "bold", style: "italic")[#upper(bloque)]
  v(0.2cm)
}

#let tarjeta(titulo, contenido) = {
  block(
    width: 100%,
    fill: gris-claro,
    stroke: 0.7pt + gris-borde,
    radius: 5pt,
    inset: 11pt,
  )[
    #text(size: 13.5pt, weight: "bold", fill: granate)[#titulo]
    #v(4pt)
    #set text(size: 12.2pt)
    #contenido
  ]
}

// ==================== LÁMINA 1: PORTADA OFICIAL ====================
#text(size: 13pt, weight: "bold", fill: granate)[
  UNIVERSIDAD NACIONAL DE SAN AGUSTÍN DE AREQUIPA
] \
#v(-6pt)
#text(size: 10.5pt, weight: "bold", fill: gris-texto)[
  FACULTAD DE INGENIERÍA DE PRODUCCIÓN Y SERVICIOS · ESCUELA PROFESIONAL DE INGENIERÍA DE SISTEMAS
]

#v(0.15cm)
#line(length: 100%, stroke: 1.5pt + granate)
#v(0.25cm)

#grid(
  columns: (1fr, 4.2cm),
  gutter: 0.8cm,
  align: (left + horizon, center + horizon),
  block(
    stroke: (left: 6pt + granate),
    inset: (left: 16pt, y: 4pt),
  )[
    #text(size: 23pt, weight: "bold", fill: azul-oscuro)[
      TECNOLOGÍA DE OBJETOS
    ] \
    #v(2pt)
    #text(size: 16pt, weight: "bold", fill: granate)[
      SGTE-UNSA: SISTEMA DE GESTIÓN DE TRÁMITES Y \
      EXPEDIENTES ACADÉMICOS EN C++17 Y QT 6
    ] \
    #v(2pt)
    #text(size: 10.2pt, fill: gris-texto, style: "italic")[
      PROYECTO FINAL · POO, PATRONES DE DISEÑO GoF, STL Y MULTITHREADING · GRUPO B (2026-B)
    ]

    #v(0.4cm)
    #grid(
      columns: (1fr, 1.35fr),
      gutter: 0.8cm,
      [
        #text(size: 11.5pt, weight: "bold", fill: granate)[Docente:] \
        #v(2pt)
        #text(size: 12.5pt)[Mg. Roni Guillermo Apaza Aceituno]
      ],
      [
        #text(size: 11.5pt, weight: "bold", fill: granate)[Integrantes del Equipo:] \
        #v(2pt)
        #text(size: 11.5pt)[
          1. Choquehuanca Bedoya, Brayan Denilson \
          2. Callo Ccagiavilca, Kevin Joel \
          3. Ticona Saure, Jose Maria
        ]
      ],
    )
  ],
  image("../img/escudo_unsa.png", width: 3.9cm),
)

#v(1fr)
#block(
  fill: fondo-card,
  stroke: (left: 4.5pt + granate),
  inset: (x: 12pt, y: 8pt),
  radius: (right: 4pt),
  width: 100%,
)[
  #text(size: 9.5pt, weight: "bold", fill: granate)[ENFOQUE DEL PROYECTO] \
  #v(-3pt)
  #text(size: 11pt)[
    Aplicación de escritorio con arquitectura MVC que integra herencia polimórfica, punteros inteligentes (`std::shared_ptr`), plantillas genéricas (`Repositorio<T>`), expresiones lambda con STL, patrones GoF (*Singleton*, *Factory Method*, *Strategy*, *Decorator*) y auditoría concurrente con `QThread`.
  ]
]

#pagebreak()

// ==================== LÁMINA 2 ====================
#titulo_lamina(
  "Arquitectura de Software y Contexto Institucional",
  "1. Propósito del Sistema y Arquitectura MVC + Singleton",
)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.8cm,
  tarjeta("Problemática y Solución (SGTE-UNSA)")[
    - Los trámites universitarios (_Matrícula_, _Carta de Prácticas_, _Grado de Bachiller_) tienen *tasas, prioridades y descuentos distintos*.
    - *SGTE-UNSA* desacopla las reglas de negocio de la interfaz gráfica mediante C++17 y Qt 6 Widgets.
    - Persistencia inmediata en archivos planos (`tramites_unsa.csv`) sin requerir servidores externos.
  ],
  tarjeta("Patrón Arquitectónico MVC + Singleton")[
    - *Modelo (`Tramite`, `Repositorio<T>`):* Entidades polimórficas, cálculo de tasas y almacenamiento genérico.
    - *Vista (`MainWindow`):* Formulario, tabla interactiva y barra de progreso en Qt Widgets.
    - *Controlador (`ControladorTramites`):* Coordina eventos de la Vista hacia el Modelo.
    - *Singleton (`ConfiguracionUNSA`):* Instancia única con el semestre activo (`2026-B`) y ruta del archivo CSV.
  ],
)

#v(0.35cm)
#tarjeta("Flujo de Comunicación entre Capas")[
  `Usuario (Qt GUI)` $->$ `MainWindow (Vista)` $->$ `ControladorTramites (Controlador)` $->$ `TramiteFactory / Repositorio<Tramite> (Modelo)` $->$ `tramites_unsa.csv`
]

#pagebreak()

// ==================== LÁMINA 3 ====================
#titulo_lamina(
  "Programación Orientada a Objetos en C++17",
  "2. Encapsulación, Herencia y Polimorfismo Dinámico",
)

#grid(
  columns: (1.05fr, 1.25fr),
  gutter: 0.7cm,
  tarjeta("Jerarquía Polimórfica (Tramite.h)")[
    - *Clase Base Abstracta `Tramite`:*
      - Atributos protegidos: `codigo_`, `dniEstudiante_`, `nombreEstudiante_`, `tasaBase_`, `estado_`.
      - Métodos virtuales puros (`= 0`):
        - `calcularCostoFinal() const`
        - `obtenerPrioridad() const`
        - `obtenerTipo() const`
    - *3 Subclases Concretas (`override`):*
      1. `TramiteMatricula`: Prioridad `2` (Media) | Base `S/ 30.00`.
      2. `TramiteCartaPracticas`: Prioridad `3` (Normal) | Base `S/ 15.00`.
      3. `TramiteGradoBachiller`: Prioridad `1` (Alta) | Base `S/ 180.00 + S/ 20.00` (diploma).
  ],
  block(
    width: 100%,
    stroke: 0.7pt + gris-borde,
    radius: 5pt,
    inset: 10pt,
  )[
    #set text(font: "Consolas", size: 9.8pt)
    ```cpp
    class Tramite {
    protected:
        std::string codigo_, dniEstudiante_, nombreEstudiante_;
        double tasaBase_;
        std::shared_ptr<IEstrategiaTasa> estrategiaTasa_;
    public:
        virtual ~Tramite() = default;
        virtual std::string obtenerTipo() const = 0;
        virtual double calcularCostoFinal() const = 0;
        virtual int obtenerPrioridad() const = 0;
    };

    class TramiteGradoBachiller : public Tramite {
    public:
        std::string obtenerTipo() const override {
            return "Grado Bachiller";
        }
        double calcularCostoFinal() const override {
            return estrategiaTasa_->calcularMonto(tasaBase_) + 20.0;
        }
        int obtenerPrioridad() const override { return 1; }
    };
    ```
  ],
)

#pagebreak()

// ==================== LÁMINA 4 ====================
#titulo_lamina(
  "Patrones Creacionales y Gestión Automática de Memoria",
  "3. Patrón Factory Method y Punteros Inteligentes",
)

#grid(
  columns: (1fr, 1.2fr),
  gutter: 0.7cm,
  tarjeta("Desacoplamiento con TramiteFactory")[
    - La ventana Qt (`MainWindow`) *nunca invoca `new`* ni conoce las subclases concretas.
    - Envía los textos del formulario a `TramiteFactory::crearTramite(...)`.
    - Uso de *`std::shared_ptr<Tramite>`* y *`std::make_shared`* (`<memory>`): liberación automática RAII sin fugas de memoria (_memory leaks_).
  ],
  block(
    width: 100%,
    stroke: 0.7pt + gris-borde,
    radius: 5pt,
    inset: 10pt,
  )[
    #set text(font: "Consolas", size: 9.6pt)
    ```cpp
    std::shared_ptr<Tramite> TramiteFactory::crearTramite(
        const std::string& tipo, const std::string& codigo,
        const std::string& dni, const std::string& nombre,
        const std::string& modalidadTasa, bool urgente)
    {
        auto estrategia = crearEstrategia(modalidadTasa);
        std::shared_ptr<Tramite> nuevo;

        if (tipo == "Matricula")
            nuevo = std::make_shared<TramiteMatricula>(...);
        else if (tipo == "Carta Practicas")
            nuevo = std::make_shared<TramiteCartaPracticas>(...);
        else if (tipo == "Grado Bachiller")
            nuevo = std::make_shared<TramiteGradoBachiller>(...);

        if (urgente)
            nuevo = std::make_shared<TramiteUrgenteDecorator>(nuevo);
        return nuevo;
    }
    ```
  ],
)

#pagebreak()

// ==================== LÁMINA 5 ====================
#titulo_lamina(
  "Patrones Estructurales y de Comportamiento",
  "4. Patrones GoF: Strategy (Tasas) y Decorator (Urgencia)",
)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.7cm,
  tarjeta("Patrón Strategy (EstrategiaTasa.h)")[
    - Interfaz `IEstrategiaTasa` con método virtual puro `calcularMonto(double tasaBase) const`.
    - *3 Estrategias intercambiables:*
      1. `EstrategiaTasaRegular`: cobra el *100%* de la tasa.
      2. `EstrategiaTasaBeca`: aplica *50% de descuento*.
      3. `EstrategiaTasaExonerado`: costo *S/ 0.00*.
    - Evita bloques condicionales `if/else` dentro de cada trámite.
  ],
  tarjeta("Patrón Decorator (TramiteUrgenteDecorator)")[
    - Envuelve dinámicamente cualquier `std::shared_ptr<Tramite>` cuando se marca _"Atención Urgente"_.
    - *Sin modificar las subclases (Principio OCP - SOLID):*
      - Añade `[URGENTE]` al nombre del tipo.
      - Suma `+S/ 20.00` al resultado de `calcularCostoFinal()`.
      - Eleva la prioridad a *`0 - URGENTE`*.
  ],
)

#v(0.3cm)
#block(
  width: 100%,
  stroke: 0.7pt + gris-borde,
  radius: 5pt,
  inset: 9pt,
)[
  #set text(font: "Consolas", size: 9.6pt)
  ```cpp
  class TramiteUrgenteDecorator : public Tramite {
      std::shared_ptr<Tramite> tramiteEnvuelto_;
  public:
      double calcularCostoFinal() const override { return tramiteEnvuelto_->calcularCostoFinal() + 20.0; }
      int obtenerPrioridad() const override { return 0; }
  };
  ```
]

#pagebreak()

// ==================== LÁMINA 6 ====================
#titulo_lamina(
  "Características Avanzadas de C++ y Robustez",
  "5. Sobrecarga de Operadores, inline/const/friend y Excepciones",
)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.7cm,
  tarjeta("C++ Avanzado en Tramite")[
    - *`inline` y `const`:* Accesores seguros (`getCodigo() const`, `getDni() const`) sin costo de llamada.
    - *Sobrecarga de `operator<`:* Compara primero `obtenerPrioridad()` (`0 < 1 < 2 < 3`) y luego el código.
    - *Sobrecarga de `operator==`:* Detecta expedientes duplicados por código.
    - *Función `friend operator<<`:* Formatea el objeto hacia `std::ostream` para el reporte de auditoría.
  ],
  tarjeta("Jerarquía de Excepciones (Excepciones.h)")[
    - Hereda de `std::runtime_error`:
      - `ExcepcionTramite` (clase base)
      - `ExcepcionValidacion` (DNI inválido $!= 8$ dígitos, campos vacíos o código duplicado)
      - `ExcepcionPersistencia` (fallo de apertura CSV)
    - Capturadas con `try / catch` en la interfaz Qt mostrando diálogos `QMessageBox::warning`.
  ],
)

#v(0.3cm)
#block(
  width: 100%,
  stroke: 0.7pt + gris-borde,
  radius: 5pt,
  inset: 9pt,
)[
  #set text(font: "Consolas", size: 9.6pt)
  ```cpp
  bool operator<(const Tramite& otro) const {
      if (this->obtenerPrioridad() != otro.obtenerPrioridad())
          return this->obtenerPrioridad() < otro.obtenerPrioridad();
      return this->codigo_ < otro.codigo_;
  }
  ```
]

#pagebreak()

// ==================== LÁMINA 7 ====================
#titulo_lamina(
  "Programación Genérica y Persistencia de Datos",
  "6. Plantilla Repositorio<T> y Almacenamiento en CSV",
)

#grid(
  columns: (1fr, 1.25fr),
  gutter: 0.7cm,
  tarjeta("Diseño Genérico (Repositorio.h)")[
    - Clase plantilla *`template <typename T> class Repositorio`* independiente del tipo de entidad.
    - Respaldada internamente por `std::vector<std::shared_ptr<T>>` garantizando memoria contigua para los punteros y desacoplamiento de la GUI.
    - *Persistencia automática:* Cada alta, baja o cambio de estado invoca `guardarEnCSV("tramites_unsa.csv")`.
  ],
  block(
    width: 100%,
    stroke: 0.7pt + gris-borde,
    radius: 5pt,
    inset: 10pt,
  )[
    #set text(font: "Consolas", size: 9.4pt)
    ```cpp
    template <typename T>
    class Repositorio {
    private:
        std::vector<std::shared_ptr<T>> elementos_;
    public:
        void agregar(std::shared_ptr<T> item) {
            auto it = std::find_if(elementos_.begin(), elementos_.end(),
                [&item](const auto& act) { return *act == *item; });
            if (it != elementos_.end())
                throw ExcepcionValidacion("Codigo duplicado");
            elementos_.push_back(std::move(item));
        }

        template <typename Predicado>
        std::vector<std::shared_ptr<T>> filtrar(Predicado pred) const {
            std::vector<std::shared_ptr<T>> res;
            std::copy_if(elementos_.begin(), elementos_.end(),
                         std::back_inserter(res), pred);
            return res;
        }
    };
    ```
  ],
)

#pagebreak()

// ==================== LÁMINA 8 ====================
#titulo_lamina(
  "Paradigma Funcional y Librería Estándar STL",
  "7. Expresiones Lambda, Algoritmos STL y Señales en Qt",
)

#grid(
  columns: (1fr, 1.15fr),
  gutter: 0.7cm,
  tarjeta("Algoritmos STL con Lambdas en Acción")[
    1. *`std::find_if`:* Busca expedientes por código y previene duplicados.
    2. *`std::copy_if`:* Filtra la tabla en tiempo real según texto y estado.
    3. *`std::count_if`:* Calcula cuántos trámites están _Pendientes_ y cuántos son _Urgentes_.
    4. *`std::accumulate`:* Suma la liquidación total en soles (`S/ 372.50`).
    5. *`std::sort`:* Ordena toda la colección por prioridad invocando `operator<`.
  ],
  block(
    width: 100%,
    stroke: 0.7pt + gris-borde,
    radius: 5pt,
    inset: 10pt,
  )[
    #set text(font: "Consolas", size: 9.4pt)
    ```cpp
    double calcularMontoTotal() const {
        return std::accumulate(elementos_.begin(), elementos_.end(), 0.0,
            [](double acum, const std::shared_ptr<T>& item) {
                return acum + item->calcularCostoFinal();
            });
    }

    void ordenarPorPrioridad() {
        std::sort(elementos_.begin(), elementos_.end(),
            [](const auto& a, const auto& b) { return *a < *b; });
    }

    connect(txtBuscar_, &QLineEdit::textChanged, this,
            [this](const QString&) { actualizarTabla(); });
    ```
  ],
)

#pagebreak()

// ==================== LÁMINA 9 ====================
#titulo_lamina(
  "Programación Concurrente y Procesamiento Asíncrono",
  "8. Multithreading con QThread y Objeto Función (Functor)",
)

#grid(
  columns: (1fr, 1.2fr),
  gutter: 0.7cm,
  tarjeta("Auditoría en Segundo Plano (HiloProcesador.h)")[
    - *Objeto Función (`EvaluadorPrioridadFunctor`):* Sobrecarga `operator()` para detectar expedientes de prioridad alta/urgente aún no atendidos.
    - *`HiloProcesador : public QThread`:*
      - Recibe una copia segura del vector de punteros inteligentes (evita condiciones de carrera).
      - Emite señales `progresoActualizado(int, QString)` hacia el `QProgressBar` de la GUI sin congelar la ventana.
      - Exporta el resumen en `reporte_auditoria.txt`.
  ],
  block(
    width: 100%,
    stroke: 0.7pt + gris-borde,
    radius: 5pt,
    inset: 10pt,
  )[
    #set text(font: "Consolas", size: 9.3pt)
    ```cpp
    struct EvaluadorPrioridadFunctor {
        bool operator()(const std::shared_ptr<Tramite>& t) const {
            return t->obtenerPrioridad() <= 1 &&
                   t->getEstado() != "Atendido";
        }
    };

    void HiloProcesador::run() {
        EvaluadorPrioridadFunctor esPrioritario;
        for (int i = 0; i < total; ++i) {
            if (esPrioritario(copiaTramites_[i]))
                ++prioritariosPendientes;
            reporte << (i + 1) << ". " << *copiaTramites_[i] << "\n";
            QThread::msleep(180);
            emit progresoActualizado(((i + 1) * 100) / total, msg);
        }
        emit procesamientoFinalizado(resumen);
    }
    ```
  ],
)

#pagebreak()

// ==================== LÁMINA 10 ====================
#titulo_lamina(
  "Verificación Experimental y Resultados",
  "9. Demostración de la Interfaz Qt 6 y Conclusiones",
)

#grid(
  columns: (1.35fr, 1fr),
  gutter: 0.6cm,
  align(center + horizon)[
    #image("../img/auditoria_multihilo_sgte.png", width: 100%)
  ],
  tarjeta("Conclusiones del Proyecto")[
    1. *Cobertura Integral:* Integra POO, polimorfismo, `std::shared_ptr`, excepciones, plantillas, STL/lambdas, multithreading y patrones GoF.
    2. *Bajo Acoplamiento (SOLID + MVC):* _Strategy_ y _Decorator_ permiten combinar tasas y urgencias sin multiplicar subclases.
    3. *Interfaz Reactiva:* La auditoría en `QThread` mantiene la ventana fluida al 100% mientras genera reportes en disco.
  ],
)
