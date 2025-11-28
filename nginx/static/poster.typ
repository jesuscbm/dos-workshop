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
#let c_muted   = rgb("#767fc9")

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
    #v(-2em)
    #text(size: 3.3em, weight: "bold", fill: c_muted)[Agotamiento de Recursos de Capa 7]
  ]

  #v(3em)

  // 3. GANCHO Y DESCRIPCIÓN
  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    
    // COLUMNA IZQUIERDA: TEXTO
    align(horizon)[
      #text(size: 2.4em, fill: c_muted)[
        Identificación, explotación y mitigación en APIs modernas.
      ]
      #v(1em)
      
      #list(
        marker: text(fill: c_success, size: 2em)[✔], 
        indent: 0.5em,
        spacing: 1em,
        [#text(size: 2.2em)[Arquitectura Botnet C&C]],
        [#text(size: 2.2em)[HTTP Flooding & SSRF]],
        [#text(size: 2.2em)[Docker & Nginx Hardening]],
        [#text(size: 2.2em)[Hacking Ético en Entorno Real]]
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
        #text(size: 1.5em, fill: c_success)[user\@seif:~/botnet\$] #text(size: 1.4em)[python3 attack.py --target 192.168.1.10] \
        #v(1em)
        #text(size: 1.4em, fill: c_muted)[[\*] Loading payload: Resource Exhaustion...] \
        #text(size: 1.4em, fill: c_muted)[[\*] Connecting to 50 zombies...] \
        #text(size: 1.4em, fill: c_muted)[[\*] Target: ONLINE (200 OK)] \
        #v(1em)
        #text(size: 1.4em, fill: c_success)[> LAUNCHING ATTACK SEQUENCE...] \
        #v(1em)
        #text(size: 1.4em, fill: c_alert)[ ERR_CONNECTION_TIMED_OUT (504)] \
        #text(size: 1.4em, fill: c_alert)[ SERVICE UNAVAILABLE (503)] \
        #text(size: 1.4em, fill: c_alert)[ SYSTEM CRASH DETECTED.] \
        #v(1em)
        #text(size: 1.4em, fill: c_success)[user\@seif:~/botnet\$] \_
        #place(bottom + right, dy: 1em, dx: 1em)[
           #text(size: 5em, fill: rgb(255, 255, 255, 20))[☠]
        ]
      ]
    )
  )

  #v(2em)

  // 4. CAJA DE ORGANIZACIÓN (LOGO)
  #align(center)[
    #block(
        fill: c_dark,
        stroke: (paint: c_muted, thickness: 2pt),
        radius: 16pt,
        inset: 2em,
        width: 50%, 
        stack(
            dir: ttb,
            spacing: 1em,
            text(size: 1.5em, weight: "bold", fill: c_muted)[ORGANIZADO POR],
            image("logo.png", height: 13em, fit: "contain"),
        )
    )
  ]

  #v(2em)

  // 5. CAJA DE REQUISITOS (AUMENTADO)
  #align(center)[
    #block(
      fill: c_block,
      stroke: (paint: c_accent, thickness: 2pt, dash: "dashed"),
      radius: 8pt,
      inset: 2em,
      width: 95%,
      [
        #text(size: 2em, weight: "bold", fill: c_accent)[REQUISITOS:]
        #h(1em)
        #text(size: 1.8em)[Portátil (Linux/Win/Mac) + Python 3 + Ganas de romper cosas]
      ]
    )
  ]
  
  #v(1fr)

  // 6. FOOTER CON LOGÍSTICA (AUMENTADO)
  #grid(
    columns: (1fr, 1fr),
    align(center)[
      #text(size: 2em, fill: c_muted)[CUÁNDO] \
      #v(0.2em)
      #text(size: 3em, weight: "bold", fill: c_text)[28 DE NOV] \
      #text(size: 2.2em, weight: "bold", fill: c_text)[13:00 H - 15:00 H]
    ],
    align(center)[
      #text(size: 2em, fill: c_muted)[DÓNDE] \
      #v(0.2em)
      #text(size: 3em, weight: "bold", fill: c_text)[AULA 4] \
      #text(size: 2.2em, fill: c_text)[Escuela Politécnica]
    ]
  )
]

// Barra inferior decorativa
#place(bottom, block(fill: c_accent, width: 100%, height: 1.5em))
