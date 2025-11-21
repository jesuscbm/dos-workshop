#import "@preview/polylux:0.4.0": *

// --- COLORES (Tokyo Night Theme) ---
#let c_bg      = rgb("#1a1b26") // Fondo Principal
#let c_text    = rgb("#a9b1d6") // Texto Principal
#let c_accent  = rgb("#7aa2f7") // Azul (Acentos)
#let c_alert   = rgb("#f7768e") // Rojo (Alertas)
#let c_success = rgb("#9ece6a") // Verde (Éxito/Código)
#let c_warning = rgb("#e0af68") // Naranja (Avisos)
#let c_muted   = rgb("#565f89") // Gris/Azul apagado (Bordes, Comentarios)
#let c_block   = rgb("#24283b") // Fondo de Bloques/Cajas
#let c_code_bg = rgb("#16161e") // Fondo de Terminal/Código
#let c_code    = rgb("#c0caf5") // Texto de Código
#let c_header  = rgb("#414868") // Fondo de Cabeceras (OSI)

// Configuración Visual "Dark Mode"
#set page(paper: "presentation-16-9", fill: c_bg)
#set text(font: "FiraCode Nerd Font Mono", fill: c_text, size: 20pt)

// Funciones auxiliares para estilo
#let accent(it) = text(fill: c_accent, weight: "bold", it)
#let alert(it) = text(fill: c_alert, weight: "bold", it)
#let code_block(it) = block(
  fill: c_block,
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  text(fill: c_code, font: "FiraCode Nerd Font Mono", size: 16pt, it)
)

// --- INICIO PRESENTACIÓN ---

#slide[
  #align(center + horizon)[
    #text(size: 2em, weight: "bold", fill: c_accent)[Taller DoS]
    
    #v(1em)
    Protocolos y agotamiento de recursos
    

    #v(1em)
      #image("logo.png", height:4em)
    #text(size: 0.6em)[ SEIF, Jesús Blázquez | UAM]
  ]
]

#slide[
  #align(center)[= Seguridad de la Información: CIA]
  #v(1em)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8em,
    align(center + horizon)[
      #box(stroke: 2pt + c_muted, inset: 15pt, radius: 5pt)[
        #text(size: 0.8em)[Confidencialidad]
      ]
    ],
    align(center + horizon)[
      #box(stroke: 2pt + c_muted, inset: 15pt, radius: 5pt)[
        #text(size: 0.8em)[Integridad]
      ]
    ],
    align(center + horizon)[
      #box(fill: c_alert, inset: 15pt, radius: 5pt)[
        #text(fill: c_bg, weight: "bold", size: 0.8em)[Disponibilidad]
      ]
    ]
  )

  #v(0.5em)
  #align(center)[
    #text(size: 1.5em, fill: c_alert)[$ arrow.b $]
  ]
  #v(0.5em)

  #align(center)[
    #box(fill: c_block, inset: 1em, radius: 5pt, width: 95%)[
      #accent[Denial of Service (DoS)] \
      #v(0.2em)
      #text(size: 0.8em)[
        "Cualquier evento que disminuya o elimine la capacidad de un sistema para realizar la función para la que fue diseñado."
      ]
    ]
  ]
]

#slide[
  #align(center)[= El Concepto: DoS vs DDoS]
  #v(1em)

  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 2em,
    align(horizon)[
      #text(size: 0.85em)[
        #accent[DoS (Denial of Service)]
        - 1 Atacante vs 1 Objetivo.
        - Origen único.
        - Fácil de mitigar (Bloqueo de IP / Firewall).

        #v(1.5em)

        #alert[DDoS (Distributed DoS)]
        - N Atacantes (Botnet) vs 1 Objetivo.
        - Múltiples orígenes coordinados.
        - Tráfico indistinguible del real.
        - Difícil de mitigar en el origen.
      ]
    ],
    align(center + horizon)[
      // --- ESQUEMA BOTNET ---
      #block(
        fill: c_code_bg,
        inset: 1em,
        radius: 12pt,
        stroke: (paint: c_muted, thickness: 1pt),
        width: 100%,
        stack(
          dir: ttb,
          spacing: 0.5em,

          // 1. El Atacante (Botmaster)
          stack(dir: ttb, spacing: 0.3em,
            circle(radius: 12pt, fill: c_alert, stroke: 2pt + c_block),
            text(size: 0.6em, fill: c_alert, weight: "bold")[Atacante]
          ),

          // Flecha de Comando (C&C)
          text(fill: c_muted, size: 0.8em)[$ arrow.b $],

          // 2. La Botnet (Tus compañeros)
          block(
            stroke: (paint: c_accent, dash: "dashed"),
            radius: 8pt,
            inset: 0.8em,
            fill: c_block,
            stack(dir: ttb, spacing: 0.5em,
                grid(
                    columns: (1fr, 1fr, 1fr),
                    gutter: 0.5em,
                    circle(radius: 7pt, fill: c_accent),
                    circle(radius: 7pt, fill: c_accent),
                    circle(radius: 7pt, fill: c_accent),
                ),
                text(size: 0.6em, fill: c_accent)[Botnet]
            )
          ),

          // 3. El Ataque (Múltiples vectores)
          grid(
            columns: (1fr, 1fr, 1fr),
            text(fill: c_alert, weight: "bold")[$ arrow.b $],
            text(fill: c_alert, weight: "bold")[$ arrow.b.double $],
            text(fill: c_alert, weight: "bold")[$ arrow.b $],
          ),

          // 4. El Objetivo (Target)
          block(
            fill: c_alert,
            inset: 0.6em,
            radius: 4pt,
            width: 60%,
            text(size: 0.7em, weight: "bold", fill: c_bg)[TARGET]
          )
        )
      )
    ]
  )
]

#slide[
  #align(center)[= Botnets: Infraestructura Distribuida]
  #v(1em)

  #grid(
    columns: (1.3fr, 0.7fr),
    gutter: 2em,
    align(horizon)[
      #block(fill: c_block, inset: 1em, radius: 8pt, width: 100%)[
        #accent[Definición] \
        #v(0.2em)
        #text(size: 0.8em)[Red de dispositivos infectados ("Zombies") operados por un actor central ("Botmaster") sin el conocimiento de sus propietarios.]
      ]
      
      #v(1em)
      
      #text(size: 0.75em)[
        - *Amplificación:* 1 Orden $->$ N Ataques.
        - *Anonimato:* El tráfico no viene del atacante.
        - *Resiliencia:* Si un nodo cae, quedan miles.
      ]
    ],
    
    align(center + horizon)[
      #block(
        stroke: (paint: c_muted, dash: "dashed"), 
        radius: 8pt, 
        inset: 1em,
        fill: c_code_bg
      )[
        #stack(dir: ttb, spacing: 0.3em,
          // Botmaster
          circle(radius: 12pt, fill: c_alert),
          text(size: 0.6em, fill: c_alert, weight: "bold")[Botmaster],
          
          v(0.2em),
          text(fill: c_muted)[$ arrow.b $],
          v(0.2em),
          
          // Bots Grid
          grid(
            columns: (1fr, 1fr, 1fr),
            gutter: 0.5em,
            circle(radius: 8pt, fill: c_accent),
            circle(radius: 8pt, fill: c_accent),
            circle(radius: 8pt, fill: c_accent)
          ),
          text(size: 0.6em, fill: c_accent)[Zombies]
        )
      ]
    ]
  )
]


#slide[
  #align(center)[= El Principio de Asimetría]
  #v(2em)

  #grid(
    columns: (1fr, 0.2fr, 1fr),
    align(top + center)[
      #text(weight: "bold", fill: c_accent)[Cliente (Tú)]
      #v(.5em)
      #block(
        fill: c_block, inset: 15pt, radius: 8pt, width: 100%,
        height: 9em, // Altura fija
        align(center + horizon)[#text(size: .9em)[
          Generar Texto \
          (HTTP Request)
        ]
          #v(.5em)
          #text(size: 2em)[⚡]
        ]
      )
      #v(0.5em)
      #text(size: 0.8em)[Coste: Insignificante]
    ],

    align(horizon + center)[#text(size: 2em)[$>>$]],

    align(top + center)[
      #text(weight: "bold", fill: c_alert)[Servidor (Víctima)]
      #v(.5em)
      #block(
        fill: c_block, inset: 15pt, radius: 8pt, width: 100%,
        height: 9em, // Altura fija
        align(left + horizon)[#text(size: .9em)[
          1. Parsear TCP/HTTP \
          2. Validar JSON \
          3. Reservar Memoria (RAM) \
          4. Ciclos de CPU (Lógica) \
          5. I/O Wait (Disco/Red)
        ]]
      )
      #v(0.5em)
      #text(size: 0.8em)[Coste: Exponencial]
    ]
  )
]

#slide[
  #align(center)[= El Modelo OSI]
  #v(1em)

  // Función auxiliar para dibujar capas
  #let osi_layer(num, name, protos, bg_color, text_color) = block(
    fill: bg_color,
    inset: 0.6em,
    radius: 4pt,
    width: 70%,
    stroke: if bg_color == c_block { 1pt + c_muted } else { none },
    grid(
      columns: (1fr, 3fr, 2fr),
      align(horizon + left)[#text(weight: "bold", fill: text_color)[L#num]],
      align(horizon + center)[#text(weight: "bold", fill: text_color)[#name]],
      align(horizon + right)[#text(size: 0.7em, style: "italic", fill: text_color)[#protos]]
    )
  )

  #align(center)[
    #stack(
      dir: ttb,
      spacing: 0.3em,
      // L7: Objetivo de hoy (Resaltado fuerte)
      osi_layer(7, "Aplicación", "HTTP, DNS", c_accent, c_bg),
      
      // L6-L5: Irrelevantes hoy (Apagadas)
      osi_layer(6, "Presentación", "SSL/TLS", c_block, c_muted),
      osi_layer(5, "Sesión", "Sockets", c_block, c_muted),
      
      // L4-L3: Vectores clásicos (Resaltado medio)
      osi_layer(4, "Transporte", "TCP, UDP", c_header, c_code),
      osi_layer(3, "Red", "IP, ICMP", c_header, c_code),
      
      // L2-L1: Infraestructura (Apagadas)
      osi_layer(2, "Enlace", "MAC, ARP", c_block, c_muted),
      osi_layer(1, "Física", "Cable, WiFi", c_block, c_muted),
    )
  ]
]

#slide[
  #align(center)[= Vectores de Ataque]
  #v(1em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    
    // --- BLOQUE IZQUIERDO: L3/L4 ---
    block(
      fill: c_block,
      inset: 1em,
      radius: 8pt,
      stroke: (paint: c_muted, thickness: 1pt),
      width: 100%,
      height: 11em 
    )[
      #align(center)[#text(weight: "bold", size: 1.1em)[Volumétrico (L3/L4)]]
      #v(0.5em)
      #align(left)[
        #text(size: 0.85em)[
          - *Objetivo:* Saturar el enlace.
          - *Recurso:* Ancho de Banda.
          - *Método:* UDP/SYN/ICMP Flood.
        ]
      ]
      #v(1em)
      #align(center + bottom)[
        #rect(fill: c_bg, inset: 5pt, radius: 4pt)[
          #text(fill: c_muted, size: 0.7em)[Descartado: Colapsa WiFi]
        ]
      ]
    ],

    // --- BLOQUE DERECHO: L7 ---
    block(
      fill: c_bg,
      inset: 1em,
      radius: 8pt,
      stroke: (paint: c_alert, thickness: 2pt),
      width: 100%,
      height: 11em
    )[
      #align(center)[#text(weight: "bold", size: 1.1em, fill: c_alert)[Agotamiento (L7)]]
      #v(0.5em)
      #align(left)[
        #text(size: 0.85em)[
          - *Objetivo:* Procesamiento.
          - *Recurso:* CPU, RAM, Workers.
          - *Método:* Peticiones Complejas.
        ]
      ]
      #v(1em)
      #align(center + bottom)[
        #rect(fill: c_alert, inset: 5pt, radius: 4pt)[
          #text(fill: c_bg, weight: "bold", size: 0.7em)[OBJETIVO DEL TALLER]
        ]
      ]
    ]
  )

  #v(1.5em)
  
  #align(center)[
    #box(stroke: 1pt + c_accent, inset: 8pt, radius: 4pt)[
      *Asimetría:* #text(font: "FiraCode Nerd Font Mono", size: 0.8em)[Coste(Atacante) $<<$ Coste(Objetivo)]
    ]
  ]
]

#slide[
  #align(center)[= HTTP: Protocolo de Texto]
  #v(1em)

  #align(center)[
    #text(size: 0.8em)[Protocolo de comunicación sin estado basado en el intercambio de peticiones y respuestas entre cliente y servidor.]
  ]
  
  #v(.5em)

  #align(center)[
    #block(
      fill: c_code_bg,
      inset: 15pt,
      radius: 8pt,
      width: 55%,
      stroke: (paint: c_accent, thickness: 2pt),
      align(left)[
        #text(font: "FiraCode Nerd Font Mono", size: .8em)[
          #text(fill: c_success, weight: "bold")[POST] /api/v1/submit HTTP/1.1 \
          #text(fill: c_accent)[Host:] victim-server \
          #text(fill: c_accent)[Content-Type:] application/json \
          \
          { \
            #h(2em) "query": "search_term", \
            #h(2em) "limit": 100 \
          }
          #text(fill: c_muted, style: "italic")[\<-- Body / Datos (Opcional)]
        ]
      ]
    )
  ]

  #align(center)[

    #text(fill: c_success)[\$] `curl -X GET -H "Header: Content" -d '{"key":"value"}' http://url.com`
  ]
]

#slide[
  #align(center)[= Reglas de Compromiso]
  #v(2em)
  
  #align(center + horizon)[
    #alert[⚠️ Por motivos educativos ⚠️]
  ]
  
  1. Solo atacar la IP del laboratorio.
  2. Prohibido atacar infraestructura de la Universidad.
  3. No ataques volumétricos (UDP Flood) -> Tiraréis el AP WiFi.
  
  #v(2em)
  *Objetivo:* Entender la fragilidad para aprender a defenderla.
]

#slide[
  #align(center + horizon)[
    #text(size: 2em, weight: "bold", fill: c_alert)[A Romper Cosas]
    
    #v(1em)
    
    #block(
      fill: c_code_bg,
      inset: 1em,
      radius: 8pt,
      stroke: (paint: c_accent, thickness: 2pt),
      width: 90%,
      align(left)[
        #text(font: "FiraCode Nerd Font Mono", size: 0.85em)[
          #text(fill: c_success)[user\@botnet:~\$] python3 bot.py \
          \
          #text(fill: c_warning)[⚠] Connecting to C&C Master... \
          #text(fill: c_success)[✔] Connection Established. \
          \
          #text(fill: c_success)[user\@botnet:~\$] \_
        ]
      ]
    )
    
    #v(1em)
    #text(size: 0.9em, fill: c_text)[Abrid vuestras terminales.]
  ]
]

#slide[
  #align(center)[= Protocolo de Actuación]
  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.5em,

    // --- COLUMNA 1: INTELIGENCIA ---
    stack(
      dir: ttb,
      spacing: 0.8em, // Espaciado reducido
      align(center)[#text(fill: c_accent, weight: "bold", size: 1.1em)[Fase 1: Reconocimiento]],

      // Paso 1
      block(fill: c_code_bg, inset: 0.8em, radius: 8pt, width: 100%, stroke: (paint: c_muted, thickness: 1pt))[
        #grid(columns: (auto, 1fr), gutter: 0.8em,
          align(horizon)[#text(weight: "bold", fill: c_accent, size: 1.4em)[1.]],
          stack(dir: ttb, spacing: 0.4em,
            text(weight: "bold", fill: c_text, size: 0.95em)[Discovery],
            text(size: 0.55em)[Buscar endpoints vulnerables usando fuzzing.]
          )
        )
      ],

      // Paso 2
      block(fill: c_code_bg, inset: 0.8em, radius: 8pt, width: 100%, stroke: (paint: c_muted, thickness: 1pt))[
        #grid(columns: (auto, 1fr), gutter: 0.8em,
          align(horizon)[#text(weight: "bold", fill: c_accent, size: 1.4em)[2.]],
          stack(dir: ttb, spacing: 0.4em,
            text(weight: "bold", fill: c_text, size: 0.95em)[Fingerprinting],
            text(size: 0.55em)[Extraer información sobre los endpoints usando curl]
          )
        )
      ],

      // Paso 3
      block(fill: c_code_bg, inset: 0.8em, radius: 8pt, width: 100%, stroke: (paint: c_muted, thickness: 1pt))[
        #grid(columns: (auto, 1fr), gutter: 0.8em,
          align(horizon)[#text(weight: "bold", fill: c_accent, size: 1.4em)[3.]],
          stack(dir: ttb, spacing: 0.4em,
            text(weight: "bold", fill: c_text, size: 0.95em)[Prototipado],
            text(size: 0.55em)[Diseñar manualmente las requests con la que atacaremos cada endpoint.]
          )
        )
      ]
    ),

    // --- COLUMNA 2: ARMAMENTO ---
    stack(
      dir: ttb,
      spacing: 0.8em, // Espaciado reducido
      align(center)[#text(fill: c_alert, weight: "bold", size: 1.1em)[Fase 2: Armamento]],

      // Paso 4
      block(fill: c_code_bg, inset: 0.8em, radius: 8pt, width: 100%, stroke: (paint: c_alert, thickness: 1pt))[
        #grid(columns: (auto, 1fr), gutter: 0.8em,
          align(horizon)[#text(weight: "bold", fill: c_alert, size: 1.4em)[4.]],
          stack(dir: ttb, spacing: 0.4em,
            text(weight: "bold", fill: c_text, size: 0.95em)[Scripting],
            text(size: 0.55em)[Programar la lógica de ataque en el archivo del bot.]
          )
        )
      ],

      // Paso 5
      block(fill: c_code_bg, inset: 0.8em, radius: 8pt, width: 100%, stroke: (paint: c_alert, thickness: 1pt))[
        #grid(columns: (auto, 1fr), gutter: 0.8em,
          align(horizon)[#text(weight: "bold", fill: c_alert, size: 1.4em)[5.]],
          stack(dir: ttb, spacing: 0.4em,
            text(weight: "bold", fill: c_text, size: 0.95em)[Inyección],
            text(size: 0.55em)[Inyectar el archivo del bot al zombie. Iniciar C&C en nuestro propio ordenador]
          )
        )
      ],

      // Paso 6
      block(fill: c_block, inset: 0.8em, radius: 8pt, width: 100%, stroke: (paint: c_success, thickness: 2pt))[
        #grid(columns: (auto, 1fr), gutter: 0.8em,
          align(horizon)[#text(weight: "bold", fill: c_success, size: 1.4em)[6.]],
          stack(dir: ttb, spacing: 0.4em,
            text(weight: "bold", fill: c_success, size: 0.95em)[Atacar],
            text(size: 0.55em)[Avísanos de que estás listo. Empezar el ataque cuando te demos el visto bueno]
          )
        )
      ]
    )
  )
]


#slide[
  #align(center + horizon)[
    = Direcciones IP
    
    #v(2em)
    
    #grid(
      columns: (1fr, 1fr),
      gutter: 2em,
      align(center)[
        #text(weight: "bold", fill: c_alert)[OBJETIVO (Víctima)]
        #v(0.5em)
        #block(
          fill: c_block,
          stroke: (paint: c_alert, thickness: 2pt, dash: "dashed"),
          inset: 1.5em,
          radius: 12pt,
          width: 100%
        )[
          #text(font: "FiraCode Nerd Font Mono", size: 1.8em, weight: "bold", fill: c_alert)[192.168.X.X]
        ]
      ],
      align(center)[
        #text(weight: "bold", fill: c_accent)[BOT (Zombie)]
        #v(0.5em)
        #block(
          fill: c_block,
          stroke: (paint: c_accent, thickness: 2pt, dash: "dashed"),
          inset: 1.5em,
          radius: 12pt,
          width: 100%
        )[
          #text(font: "FiraCode Nerd Font Mono", size: 1.8em, weight: "bold", fill: c_accent)[192.168.Y.Y]
        ]
      ]
    )
    
    #v(2em)
    #text(size: 0.8em, fill: c_text)[Descargad los recursos en #text(weight: "bold", fill: c_alert)[http://192.168.X.X/static]]
  ]
]


#slide[
  #align(center)[= Objetivo 1: Workers (Bloqueo)]
  #v(0.5em)

  #grid(
    columns: (1.1fr, 0.9fr),
    gutter: 1.5em,
    align(horizon)[
      #text(weight: "bold", fill: c_accent, size: 1.1em)[Vulnerabilidad: SSRF Síncrono]
      #v(0.5em)
      #text(size: 0.8em)[
        El endpoint `/monitor` usa `requests.get()` de forma síncrona.
        
        Si le pedimos que conecte a una *API externa lenta*, el Worker de Gunicorn se queda "congelado" esperando la respuesta hasta el timeout.
        
        *Estrategia:* Usar una dirección pública que tarde en responder, o un blackhole en nuestro propio dispositivo.
      ]
    ],
    align(center + horizon)[
      #block(
        fill: c_code_bg,
        stroke: (paint: c_accent, thickness: 2pt),
        inset: 1em,
        radius: 8pt,
        width: 100%,
        align(left)[
          #text(fill: c_text, weight: "bold")[Payload:]
          #v(0.5em)
          #text(font: "FiraCode Nerd Font Mono", size: 0.8em)[
          #text(fill: c_success, weight: "bold")[GET] /monitor?target=... HTTP/1.1 \
          \
          Target URL: \
          #text(fill: c_warning, size: 0.7em)[https://httpbin.org/delay/5] \
          \
          Si no hay internet: \
          #text(fill: c_success, size: 0.8em)[\$] `nc -lkp 9000` \
          #text(fill: c_warning, size: 0.7em)[http://\<TU-IP\>:9000] \
          ]
        ]
      )
    ]
  )
]
#slide[
  #align(center)[= Objetivo 2: CPU (Cálculo)]
  #v(1em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align(horizon)[
      #text(weight: "bold", fill: c_accent, size: 1.2em)[Vulnerabilidad: Complejidad Algorítmica]
      #v(1em)
      #text(size: 0.85em)[
        El endpoint `/pi` utiliza el método de Monte Carlo para estimar $pi$.
        
        #v(1em)
        *Efecto:* El *Load Average* del servidor se dispara. Si supera el número de cores, todo el sistema se congela.
      ]
    ],
    align(center + horizon)[
      #block(
        fill: c_code_bg,
        stroke: (paint: c_accent, thickness: 2pt),
        inset: 1.5em,
        radius: 8pt,
        width: 100%,
        align(left)[
          #text(fill: c_text, weight: "bold")[Payload:]
          #v(0.5em)
          #text(font: "FiraCode Nerd Font Mono", size: 0.9em)[
            #text(fill: c_success, weight: "bold")[GET] /pi?iterations=... HTTP/1.1 \
            \
            Iterations: \
            #text(fill: c_warning)[5000000] \
            #text(size: 0.6em, style: "italic", fill: c_muted)[(Cuanto más alto, más daño)]
          ]
        ]
      )
    ]
  )
]

#slide[
  #align(center)[= Objetivo 3: RAM (Crash)]
  #v(1em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    align(horizon)[
      #text(weight: "bold", fill: c_alert, size: 1.2em)[Vulnerabilidad: Memory Leak Controlado]
      #v(1em)
      #text(size: 0.85em)[
        El endpoint `/allocations` reserva espacio en memoria con caducidad.
        Podemos "apilar" peticiones (Stacking) hasta llenar la memoria física.
        
        *Efecto:* *OOM Killer*. Linux detecta el peligro y mata el proceso del servidor.
      ]
    ],
    align(center + horizon)[
      #block(
        fill: c_code_bg,
        stroke: (paint: c_alert, thickness: 2pt), // Rojo por ser POST/Peligroso
        inset: 1.5em,
        radius: 8pt,
        width: 100%,
        align(left)[
          #text(fill: c_text, weight: "bold")[Payload:]
          #v(0.5em)
          #text(font: "FiraCode Nerd Font Mono", size: 0.9em)[
            #text(fill: c_alert, weight: "bold")[POST] /allocations HTTP/1.1 \
            #text(fill: c_accent)[Content-Type:] application/json \
            \
            { \
              #h(2em) "mb": #text(fill: c_warning)[500] \
            }
          ]
        ]
      )
    ]
  )
]

#slide[
  #align(center)[= Mitigación: Arquitectura Defensiva]
  #v(1.5em)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1.5em,
    
    // --- NIVEL 1: EDGE (Cloudflare) ---
    block(
      fill: c_code_bg,
      stroke: (paint: c_warning, thickness: 2pt),
      radius: 8pt,
      inset: 1em,
      height: 14.5em,
      width: 100%,
      align(center)[
        #text(weight: "bold", fill: c_warning, size: 1.3em)[Edge]
        #align(left + horizon)[
          #text(size: 0.75em)[
            - *CDN / Proxy:* Oculta tu IP Real para evitar ataques directos.
            - *WAF:* Reglas automáticas contra bots.
            - *Challenge:* Captchas/JS si detecta anomalías.
          ]
        ]
      ]
    ),

    // --- NIVEL 2: GATEWAY (Nginx) ---
    block(
      fill: c_code_bg,
      stroke: (paint: c_success, thickness: 2pt),
      radius: 8pt,
      inset: 1em,
      height: 14.5em,
      width: 100%,
      align(center)[
        #text(weight: "bold", fill: c_success, size: 1.3em)[Gateway]
        #align(left + horizon)[
          #text(size: 0.75em)[
            - *Rate Limit:* Frena IPs agresivas (`limit_req`).
            - *Caching:* Servir desde RAM evita tocar la CPU.
            - *Timeouts:* Cortar conexiones lentas (Slowloris).
          ]
        ]
      ]
    ),

    // --- NIVEL 3: APPLICATION (Python) ---
    block(
      fill: c_code_bg,
      stroke: (paint: c_accent, thickness: 2pt),
      radius: 8pt,
      inset: 1em,
      height: 14.5em,
      width: 100%,
      align(center)[
        #text(weight: "bold", fill: c_accent, size: 1.3em)[Application]
        #align(left + horizon)[
          #text(size: 0.75em)[
            - *Validación:* Rechazar números absurdos.
            - *Async:* Tareas pesadas a colas (Redis), nunca bloquear.
            - *Cuotas:* Límites duros de RAM por proceso.
          ]
        ]
      ]
    )
  )
]

#slide[
  #align(center + horizon)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      
      // --- COLUMNA IZQUIERDA ---
      align(center + horizon)[
        #text(size: 3em, weight: "bold", fill: c_accent)[\<EOF \/\>] 
        #v(1em)
        #text(size: 1.2em, fill: c_text)[Gracias por asistir.]
        #v(1em)
        #text(size: 0.9em, fill: c_muted)[SEIF | Jesús Blázquez]
      ],
      
      // --- COLUMNA DERECHA ---
      align(center + horizon)[
        #block(
          fill: c_code_bg,
          stroke: (paint: c_muted, thickness: 2pt),
          inset: 1.5em,
          radius: 8pt,
          width: 100%,
          align(left)[
            #text(font: "FiraCode Nerd Font Mono", size: 0.8em)[
              #text(fill: c_success)[user\@bot:~\$] shred -u history \
              #text(fill: c_muted)[> Traces wiped.] \
              \
              #text(fill: c_success)[user\@bot:~\$] ./questions.sh \
              #text(fill: c_warning)[? Waiting for input...] \
              \
              #text(fill: c_success)[user\@bot:~\$] exit \
              #text(fill: c_alert)[Session closed.]
            ]
          ]
        )
      ]
    )
  ]
]
