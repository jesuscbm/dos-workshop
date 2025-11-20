import time
import requests
import json
import random
import threading
from flask import Flask, jsonify, request

app = Flask(__name__)

# --- Resource: System Health ---
@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "up", "timestamp": time.time()})

# --- Resource: Service Monitor (SSRF / Worker Exhaustion) ---
# Reemplaza al avatar. Permite al atacante forzar al servidor a conectar
# a un 'Blackhole' o a un socket abierto por el propio alumno.
@app.route("/monitor", methods=["GET"])
def check_service():
    usage_guide = {
        "usage": "GET /monitor?target=<url>",
        "description": "Comprueba el estado de un servicio remoto mediante una request GET."
    }
    
    target = request.args.get("target")
    if not target:
        return jsonify(usage_guide), 400

    try:
        # Vulnerabilidad: Si el target es una IP que dropea paquetes o 
        # un socket abierto que no envía datos (netcat), el worker se bloquea 
        # durante 5 segundos esperando.
        # requests no es async, así que bloquea todo el proceso/hilo.
        resp = requests.get(target, timeout=5)
        return jsonify({
            "target": target, 
            "status": "alive", 
            "code": resp.status_code
        })
    except requests.exceptions.Timeout:
        return jsonify({"error": "Target timed out (Worker blocked for 5s)"}), 504
    except requests.exceptions.RequestException as e:
        return jsonify({"error": "Unreachable", "details": str(e)}), 502

# --- Resource: Pi Approximation ---
@app.route("/pi", methods=["GET"])
def get_pi():
    usage_guide = {
        "usage": "GET /pi?iterations=<int>",
        "description": "Calcula Pi usando Monte Carlo."
    }

    iterations_str = request.args.get("iterations")
    if not iterations_str:
        return jsonify(usage_guide), 400

    try:
        iterations = int(iterations_str)
    except ValueError:
        return jsonify({"error": "iterations debe ser int", "help": usage_guide}), 400

    if iterations >= 10000000:
        return jsonify({"error": "iterations demasiado alto", "help": usage_guide}), 400

    def compute_pi(limit):
        inside_circle = 0
        for _ in range(limit):
            x = random.random()
            y = random.random()
            if x**2 + y**2 <= 1.0:
                inside_circle += 1
        return (inside_circle / limit) * 4

    try:
        start_time = time.time()
        pi_val = compute_pi(iterations)
        duration = time.time() - start_time
        return jsonify({
            "iterations": iterations, 
            "value": pi_val, 
            "computation_time": duration
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# --- Resource: Memory Allocations ---
@app.route("/allocations", methods=["POST"])
def create_allocation():
    usage_guide = {
        "usage": "POST /allocations", 
        "headers": {"Content-Type": "application/json"},
        "body_required": {"mb": "int (max 500)"},
        "description": "Reserva memoria para una caché."
    }
    
    raw_data = request.get_data()
    if not raw_data:
        return jsonify(usage_guide), 400
    
    try:
        data = json.loads(raw_data)
        if "mb" not in data:
            return jsonify(usage_guide), 400
            
        size_mb = int(data["mb"])
    except (json.JSONDecodeError, ValueError):
         return jsonify({"error": "JSON invalido o tipo incorrecto", "help": usage_guide}), 400

    if size_mb > 500: size_mb = 500
    duration = 3

    def memory_hog(size, time_sec):
        try:
            dummy = bytearray(size * 1024 * 1024)
            time.sleep(time_sec)
            del dummy
        except: pass

    threading.Thread(target=memory_hog, args=(size_mb, duration)).start()
    
    return jsonify({
        "status": "created", 
        "mb": size_mb, 
        "expires_in": duration
    }), 201

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=False)
