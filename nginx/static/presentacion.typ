#import "@preview/polylux:0.4.0": *

// Configuración Visual "Dark Mode"
#set page(paper: "presentation-16-9", fill: rgb("#1a1b26"))
#set text(font: "FiraCode Nerd Font Mono", fill: rgb("#a9b1d6"), size: 20pt)

// Funciones auxiliares para estilo
#let accent(it) = text(fill: rgb("#7aa2f7"), weight: "bold", it)
#let alert(it) = text(fill: rgb("#f7768e"), weight: "bold", it)
#let code_block(it) = block(
  fill: rgb("#24283b"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  text(fill: rgb("#c0caf5"), font: "FiraCode Nerd Font Mono", size: 16pt, it)
)

// --- INICIO PRESENTACIÓN ---

#slide[
  #align(center + horizon)[
    #text(size: 2em, weight: "bold", fill: rgb("#7aa2f7"))[Taller DoS]
    
    #v(1em)
    Protocolos y agotamiento de recursos
    
    #v(2em)
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
      #box(stroke: 2pt + rgb("#565f89"), inset: 15pt, radius: 5pt)[
        #text(size: 0.8em)[Confidencialidad]
      ]
    ],
    align(center + horizon)[
      #box(stroke: 2pt + rgb("#565f89"), inset: 15pt, radius: 5pt)[
        #text(size: 0.8em)[Integridad]
      ]
    ],
    align(center + horizon)[
      #box(fill: rgb("#f7768e"), inset: 15pt, radius: 5pt)[
        #text(fill: rgb("#1a1b26"), weight: "bold", size: 0.8em)[Disponibilidad]
      ]
    ]
  )

  #v(0.5em)
  #align(center)[
    #text(size: 1.5em, fill: rgb("#f7768e"))[$ arrow.b $]
  ]
  #v(0.5em)

  #align(center)[
    #box(fill: rgb("#24283b"), inset: 1em, radius: 5pt, width: 95%)[
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
      // --- ZONA DE IMAGEN ---
      #rect(
        width: 100%, 
        height: 60%, 
        fill: rgb("#24283b"), 
        radius: 10pt, 
        stroke: (paint: rgb("#565f89"), dash: "dashed")
      )[
        #align(center + horizon)[
          #text(fill: rgb("#565f89"))[
            INSERTAR IMAGEN\
            (Esquema Botnet)
          ]
        ]
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
      #text(weight: "bold", fill: rgb("#7aa2f7"))[Cliente (Tú)]
      #v(.5em)
      #block(
        fill: rgb("#24283b"), inset: 15pt, radius: 8pt, width: 100%,
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
      #text(weight: "bold", fill: rgb("#f7768e"))[Servidor (Víctima)]
      #v(.5em)
      #block(
        fill: rgb("#24283b"), inset: 15pt, radius: 8pt, width: 100%,
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
    stroke: if bg_color == rgb("#24283b") { 1pt + rgb("#565f89") } else { none },
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
      osi_layer(7, "Aplicación", "HTTP, DNS", rgb("#7aa2f7"), rgb("#1a1b26")),
      
      // L6-L5: Irrelevantes hoy (Apagadas)
      osi_layer(6, "Presentación", "SSL/TLS", rgb("#24283b"), rgb("#565f89")),
      osi_layer(5, "Sesión", "Sockets", rgb("#24283b"), rgb("#565f89")),
      
      // L4-L3: Vectores clásicos (Resaltado medio)
      osi_layer(4, "Transporte", "TCP, UDP", rgb("#414868"), rgb("#c0caf5")),
      osi_layer(3, "Red", "IP, ICMP", rgb("#414868"), rgb("#c0caf5")),
      
      // L2-L1: Infraestructura (Apagadas)
      osi_layer(2, "Enlace", "MAC, ARP", rgb("#24283b"), rgb("#565f89")),
      osi_layer(1, "Física", "Cable, WiFi", rgb("#24283b"), rgb("#565f89")),
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
      fill: rgb("#24283b"),
      inset: 1em,
      radius: 8pt,
      stroke: (paint: rgb("#565f89"), thickness: 1pt),
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
        #rect(fill: rgb("#1a1b26"), inset: 5pt, radius: 4pt)[
          #text(fill: rgb("#565f89"), size: 0.7em)[Descartado: Colapsa WiFi]
        ]
      ]
    ],

    // --- BLOQUE DERECHO: L7 ---
    block(
      fill: rgb("#1a1b26"),
      inset: 1em,
      radius: 8pt,
      stroke: (paint: rgb("#f7768e"), thickness: 2pt),
      width: 100%,
      height: 11em
    )[
      #align(center)[#text(weight: "bold", size: 1.1em, fill: rgb("#f7768e"))[Agotamiento (L7)]]
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
        #rect(fill: rgb("#f7768e"), inset: 5pt, radius: 4pt)[
          #text(fill: rgb("#1a1b26"), weight: "bold", size: 0.7em)[OBJETIVO DEL TALLER]
        ]
      ]
    ]
  )

  #v(1.5em)
  
  #align(center)[
    #box(stroke: 1pt + rgb("#7aa2f7"), inset: 8pt, radius: 4pt)[
      *Asimetría:* 
      #text(font: "FiraCode Nerd Font Mono", size: 0.8em)[Coste(Atacante) $<<$ Coste(Objetivo)]
    ]
  ]
]

#slide[
  #align(center)[= HTTP: Protocolo de Texto]
  #v(1em)

  #align(center)[
    #text(size: 0.9em)[Protocolo de comunicación sin estado basado en el intercambio de peticiones y respuestas entre cliente y servidor.]
  ]
  
  #v(1em)

  #align(center)[
    #block(
      fill: rgb("#16161e"),
      inset: 15pt,
      radius: 8pt,
      width: 55%,
      stroke: (paint: rgb("#7aa2f7"), thickness: 2pt),
      align(left)[
        #text(font: "FiraCode Nerd Font Mono", size: .9em)[
          #text(fill: rgb("#9ece6a"), weight: "bold")[POST] /api/v1/submit HTTP/1.1 \
          #text(fill: rgb("#7aa2f7"))[Host:] victim-server \
          #text(fill: rgb("#7aa2f7"))[Content-Type:] application/json \
          \
          { \
            #h(2em) "query": "search_term", \
            #h(2em) "limit": 100 \
          }
          #text(fill: rgb("#565f89"), style: "italic")[\<-- Body / Datos (Opcional)]
        ]
      ]
    )
  ]
]

#slide[
  #align(center)[= Botnets: Infraestructura Distribuida]
  #v(1em)

  #grid(
    columns: (1.3fr, 0.7fr),
    gutter: 2em,
    align(horizon)[
      #block(fill: rgb("#24283b"), inset: 1em, radius: 8pt, width: 100%)[
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
        stroke: (paint: rgb("#565f89"), dash: "dashed"), 
        radius: 8pt, 
        inset: 1em,
        fill: rgb("#16161e")
      )[
        #stack(dir: ttb, spacing: 0.3em,
          // Botmaster
          circle(radius: 12pt, fill: rgb("#f7768e")),
          text(size: 0.6em, fill: rgb("#f7768e"), weight: "bold")[Botmaster],
          
          v(0.2em),
          text(fill: rgb("#565f89"))[$ arrow.b $],
          v(0.2em),
          
          // Bots Grid
          grid(
            columns: (1fr, 1fr, 1fr),
            gutter: 0.5em,
            circle(radius: 8pt, fill: rgb("#7aa2f7")),
            circle(radius: 8pt, fill: rgb("#7aa2f7")),
            circle(radius: 8pt, fill: rgb("#7aa2f7"))
          ),
          text(size: 0.6em, fill: rgb("#7aa2f7"))[Zombies]
        )
      ]
    ]
  )
]

#slide[
  #align(center + horizon)[
    #text(size: 2em, weight: "bold", fill: rgb("#f7768e"))[A Romper Cosas]
    
    #v(1em)
    
    #block(
      fill: rgb("#16161e"),
      inset: 1em,
      radius: 8pt,
      stroke: (paint: rgb("#7aa2f7"), thickness: 2pt),
      width: 90%,
      align(left)[
        #text(font: "FiraCode Nerd Font Mono", size: 0.85em)[
          #text(fill: rgb("#9ece6a"))[user\@botnet:~\$] python3 bot.py \
          \
          #text(fill: rgb("#e0af68"))[⚠] Connecting to C&C Master... \
          #text(fill: rgb("#9ece6a"))[✔] Connection Established. \
          \
          #text(fill: rgb("#9ece6a"))[user\@botnet:~\$] \_
        ]
      ]
    )
    
    #v(1em)
    #text(size: 0.9em, fill: rgb("#a9b1d6"))[Abrid vuestras terminales.]
  ]
]

#slide[
  #align(center)[= Arquitectura del Objetivo]
  #v(1em)

  #align(center)[
    #stack(
      dir: ttb,
      spacing: 0.3em, // Espaciado muy ajustado entre niveles

      // Flujo de Entrada
      text(size: 0.7em)[Conexión Exterior],
      text(fill: rgb("#7aa2f7"), size: 0.8em)[$ arrow.b $],

      // Capa Kernel (Base)
      block(
        fill: rgb("#414868"),
        width: 60%,
        radius: 4pt,
        inset: 0.5em,
        stroke: 1pt + rgb("#565f89"),
        text(weight: "bold", fill: rgb("#c0caf5"), size: 0.9em)[Linux Kernel (Host)]
      ),

      text(fill: rgb("#7aa2f7"), size: 0.8em)[$ arrow.b $],

      // Rejilla
      grid(
        columns: (1fr, 0.6fr),
        gutter: 1.5em,

        // IZQUIERDA: Docker
        block(
          stroke: (paint: rgb("#7aa2f7"), dash: "dashed", thickness: 2pt),
          radius: 8pt,
          inset: 0.8em, // Padding reducido
          width: 100%,
          stack(
            dir: ttb,
            spacing: 0.4em,
            text(size: 0.7em, fill: rgb("#7aa2f7"), weight: "bold")[DOCKER CONTAINER],
            
            block(fill: rgb("#1a1b26"), stroke: rgb("#9ece6a"), width: 100%, inset: 0.5em, radius: 4pt, text(size: 0.9em)[NGINX]),
            text(fill: rgb("#9ece6a"), size: 0.6em)[$ arrow.b $],
            block(fill: rgb("#1a1b26"), stroke: rgb("#f7768e"), width: 100%, inset: 0.5em, radius: 4pt, text(size: 0.9em)[FLASK APP])
          )
        ),

        // DERECHA: Bare Metal
        block(
          fill: rgb("#16161e"),
          stroke: (paint: rgb("#565f89"), thickness: 1pt),
          radius: 8pt,
          inset: 0.8em,
          width: 100%,
          stack(
            dir: ttb,
            spacing: 0.6em,
            text(size: 0.7em, style: "italic", fill: rgb("#565f89"))[Bare Metal / Host],
            block(fill: rgb("#1a1b26"), stroke: 1pt + rgb("#a9b1d6"), width: 100%, inset: 0.4em, radius: 4pt, text(size: 0.8em)[htop]),
            block(fill: rgb("#1a1b26"), stroke: 1pt + rgb("#a9b1d6"), width: 100%, inset: 0.4em, radius: 4pt, text(size: 0.8em)[SSH])
          )
        )
      )
    )
  ]
]

#slide[
  #align(center + horizon)[
    = Direcciones IP
    
    #v(2em)
    
    #grid(
      columns: (1fr, 1fr),
      gutter: 2em,
      align(center)[
        #text(weight: "bold", fill: rgb("#f7768e"))[OBJETIVO (Víctima)]
        #v(0.5em)
        #block(
          fill: rgb("#24283b"),
          stroke: (paint: rgb("#f7768e"), thickness: 2pt, dash: "dashed"),
          inset: 1.5em,
          radius: 12pt,
          width: 100%
        )[
          #text(font: "FiraCode Nerd Font Mono", size: 1.8em, weight: "bold", fill: rgb("#f7768e"))[192.168.X.X]
        ]
      ],
      align(center)[
        #text(weight: "bold", fill: rgb("#7aa2f7"))[BOT (Zombie)]
        #v(0.5em)
        #block(
          fill: rgb("#24283b"),
          stroke: (paint: rgb("#7aa2f7"), thickness: 2pt, dash: "dashed"),
          inset: 1.5em,
          radius: 12pt,
          width: 100%
        )[
          #text(font: "FiraCode Nerd Font Mono", size: 1.8em, weight: "bold", fill: rgb("#7aa2f7"))[192.168.Y.Y]
        ]
      ]
    )
    
    #v(2em)
    #text(size: 0.8em, fill: rgb("#a9b1d6"))[Configurad estas IPs en `bot.py`]
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
  #align(center)[= Objetivo 1: Workers (Bloqueo)]
  #v(0.5em)

  #grid(
    columns: (1.1fr, 0.9fr),
    gutter: 1.5em,
    align(horizon)[
      #text(weight: "bold", fill: rgb("#7aa2f7"), size: 1.1em)[Vulnerabilidad: SSRF Síncrono]
      #v(0.5em)
      #text(size: 0.8em)[
        El endpoint `/monitor` usa `requests.get()` de forma síncrona.
        
        Si le pedimos que conecte a una *API externa lenta*, el Worker de Gunicorn se queda "congelado" esperando la respuesta hasta el timeout.
        
        *Estrategia:* Usar servicios públicos de delay para bloquear el worker sin gastar nuestra CPU.
      ]
    ],
    align(center + horizon)[
      #block(
        fill: rgb("#16161e"),
        stroke: (paint: rgb("#7aa2f7"), thickness: 2pt),
        inset: 1em,
        radius: 8pt,
        width: 100%,
        align(left)[
          #text(fill: rgb("#a9b1d6"), weight: "bold")[Payload:]
          #v(0.5em)
          #text(font: "FiraCode Nerd Font Mono", size: 0.8em)[
            #text(fill: rgb("#9ece6a"), weight: "bold")[GET] /monitor?target=... HTTP/1.1 \
            \
            Target URL: \
            #text(fill: rgb("#e0af68"), size: 0.7em)[https://httpbin.org/delay/5]
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
      #text(weight: "bold", fill: rgb("#7aa2f7"), size: 1.2em)[Vulnerabilidad: Complejidad Algorítmica]
      #v(1em)
      #text(size: 0.85em)[
        El endpoint `/pi` utiliza el método de Monte Carlo para estimar $pi$.
        
        #v(1em)
        *Efecto:* El *Load Average* del servidor se dispara. Si supera el número de cores, todo el sistema se congela.
      ]
    ],
    align(center + horizon)[
      #block(
        fill: rgb("#16161e"),
        stroke: (paint: rgb("#7aa2f7"), thickness: 2pt),
        inset: 1.5em,
        radius: 8pt,
        width: 100%,
        align(left)[
          #text(fill: rgb("#a9b1d6"), weight: "bold")[Payload:]
          #v(0.5em)
          #text(font: "FiraCode Nerd Font Mono", size: 0.9em)[
            #text(fill: rgb("#9ece6a"), weight: "bold")[GET] /pi?iterations=... HTTP/1.1 \
            \
            Iterations: \
            #text(fill: rgb("#e0af68"))[5000000] \
            #text(size: 0.6em, style: "italic", fill: rgb("#565f89"))[(Cuanto más alto, más daño)]
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
      #text(weight: "bold", fill: rgb("#f7768e"), size: 1.2em)[Vulnerabilidad: Memory Leak Controlado]
      #v(1em)
      #text(size: 0.85em)[
        El endpoint `/allocations` reserva espacio en memoria con caducidad.
        Podemos "apilar" peticiones (Stacking) hasta llenar la memoria física.
        
        *Efecto:* *OOM Killer*. Linux detecta el peligro y mata el proceso del servidor.
      ]
    ],
    align(center + horizon)[
      #block(
        fill: rgb("#16161e"),
        stroke: (paint: rgb("#f7768e"), thickness: 2pt), // Rojo por ser POST/Peligroso
        inset: 1.5em,
        radius: 8pt,
        width: 100%,
        align(left)[
          #text(fill: rgb("#a9b1d6"), weight: "bold")[Payload:]
          #v(0.5em)
          #text(font: "FiraCode Nerd Font Mono", size: 0.9em)[
            #text(fill: rgb("#f7768e"), weight: "bold")[POST] /allocations HTTP/1.1 \
            #text(fill: rgb("#7aa2f7"))[Content-Type:] application/json \
            \
            { \
              #h(2em) "mb": #text(fill: rgb("#e0af68"))[500] \
            }
          ]
        ]
      )
    ]
  )
]
