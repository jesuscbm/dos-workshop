// --- CONFIGURACIÓN Y COLORES (Tokyo Night) ---
#set page(paper: "a3", margin: 0cm, fill: rgb("#1a1b26"))
#set text(font: "FiraCode Nerd Font Mono", fill: rgb("#a9b1d6"))

// Colores
#let c_bg      = rgb("#1a1b26")
#let c_dark    = rgb("#16161e")
#let c_block   = rgb("#24283b")
#let c_text    = rgb("#c0caf5")
#let c_accent  = rgb("#7aa2f7") // Azul
#let c_alert   = rgb("#f7768e") // Rojo
#let c_warn    = rgb("#e0af68") // Naranja
#let c_success = rgb("#9ece6a") // Verde
#let c_muted   = rgb("#565f89")

// --- DISEÑO ---

// 1. TIRA DE ALERTA SUPERIOR
#block(
  fill: c_alert,
  width: 100%,
  inset: 1.5em,
  align(center)[
    #text(size: 2em, weight: "bold", fill: c_bg)[⚠ WARNING: HIGH TRAFFIC DETECTED ⚠]
  ]
)

// CONTENEDOR PRINCIPAL (Con márgenes)
#block(inset: 3em)[
  
  // 2. TÍTULO GIGANTE
  #align(center)[
    #text(size: 8em, weight: "bold", fill: c_accent)[TALLER DoS]
    #v(-1em)
    #text(size: 3em, weight: "bold", fill: c_muted)[Agotamiento de Recursos de Capa 7]
  ]

  #v(3em)

  // 3. GANCHO Y DESCRIPCIÓN
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 3em,
    
    // COLUMNA IZQUIERDA: TEXTO
    align(horizon)[
      #text(size: 2.2em, weight: "bold", fill: c_text)[
        Ataque y Defensa de Infraestructuras Web.
      ]
      #v(1.5em)
      #text(size: 1.4em, fill: c_muted)[
        Aprende a identificar, explotar y mitigar vulnerabilidades de agotamiento de recursos en APIs modernas.
      ]
      #v(1.5em)
      
      // FIX: Lista separada por comas para que se renderice bien
      #list(
        marker: text(fill: c_success)[✔], 
        indent: 0.5em,
        spacing: 1em,
        [#text(size: 1.3em)[Arquitectura Botnet C&C]],
        [#text(size: 1.3em)[HTTP Flooding & SSRF]],
        [#text(size: 1.3em)[Docker & Nginx Hardening]],
        [#text(size: 1.3em)[Hacking Ético en Entorno Real]]
      )
    ],

    // COLUMNA DERECHA: VISUAL (TERMINAL)
    block(
      fill: c_dark,
      stroke: (paint: c_warn, thickness: 3pt),
      radius: 12pt,
      inset: 2em,
      width: 100%,
      [
        #text(size: 1.2em, fill: c_success)[user\@seif:~/botnet\$] #text(size: 1.2em)[python3 attack.py --target 192.168.1.10] \
        #v(0.5em)
        #text(size: 1.1em, fill: c_muted)[[\*] Loading payload: Resource Exhaustion...] \
        #text(size: 1.1em, fill: c_muted)[[\*] Connecting to 50 zombies...] \
        #text(size: 1.1em, fill: c_muted)[[\*] Target status: ONLINE (200 OK)] \
        #text(size: 1.1em, fill: c_success)[> LAUNCHING ATTACK SEQUENCE...] \
        #v(0.5em)
        #text(size: 1.1em, fill: c_alert)[ ERR_CONNECTION_TIMED_OUT (504)] \
        #text(size: 1.1em, fill: c_alert)[ SERVICE UNAVAILABLE (503)] \
        #text(size: 1.1em, fill: c_alert)[ SYSTEM CRASH DETECTED.] \
        #v(0.5em)
        #text(size: 1.2em, fill: c_success)[user\@seif:~/botnet\$] \_
        #place(bottom + right, dy: 1em, dx: 1em)[
           #text(size: 5em, fill: rgb(255, 255, 255, 20))[☠]
        ]
      ]
    )
  )

  #v(6em) // Espacio ajustado

  // 4. CAJA DE REQUISITOS
  #align(center)[
    #block(
      fill: c_block,
      stroke: (paint: c_accent, thickness: 2pt, dash: "dashed"),
      radius: 8pt,
      inset: 1.5em,
      width: 90%,
      [
        #text(size: 1.5em, weight: "bold", fill: c_accent)[REQUISITOS DEL SISTEMA:]
        #h(1em)
        #text(size: 1.3em)[Portátil (Linux/Win/Mac) + Python 3 + Ganas de romper cosas]
      ]
    )
  ]
  
  #v(1fr) // Empuja lo siguiente al fondo

  // 5. FOOTER CON LOGÍSTICA (A Rellenar)
  #grid(
    columns: (1fr, 1fr, 1fr),
    align(center)[
      #text(size: 1.5em, fill: c_muted)[CUÁNDO] \
      #v(0.2em)
      #text(size: 2em, weight: "bold", fill: c_text)[28 DE NOV] \
      #text(size: 1.5em, weight: "bold", fill: c_text)[13:00 H - 15:00 H]
    ],
    align(center)[
      #text(size: 1.5em, fill: c_muted)[DÓNDE] \
      #v(0.2em)
      #text(size: 2em, weight: "bold", fill: c_text)[AULA XX] \
      #text(size: 1.2em, fill: c_text)[Escuela Politécnica]
    ],
    align(center)[
      #text(size: 1.5em, fill: c_muted)[ORGANIZA] \
      #v(0.2em)
      #text(size: 2.5em, weight: "bold", fill: c_accent)[SEIF]
    ]
  )
]

// Barra inferior decorativa
#place(bottom, block(fill: c_accent, width: 100%, height: 1.5em))
