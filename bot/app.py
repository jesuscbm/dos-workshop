from flask import Flask, jsonify, request, render_template_string
import subprocess

app = Flask(__name__)

TOOL_PAGE_HTML = """
<!DOCTYPE html>
<html lang="es">
<head><title>Herramienta de Diagnóstico</title></head>
<body style="font-family: sans-serif; background-color: #f0f0f0;">
    <h2>Herramienta de Diagnóstico de Red Interna</h2>
    <p>Use esta utilidad para comprobar la conectividad con otros servidores.</p>
    <form id="ping-form">
        IP o Host: <input type="text" id="host" value="127.0.0.1">
        <button type="submit">Hacer Ping</button>
    </form>
    <hr>
    <h3>Resultado:</h3>
    <pre id="resultado" style="background-color: #333; color: #0f0; padding: 10px; border-radius: 5px;">---</pre>

    <script>
        document.getElementById("ping-form").onsubmit = async (e) => {
            e.preventDefault();
            let host = document.getElementById("host").value;
            let res = await fetch("/api/diag/ping", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ "host": host })
            });
            let data = await res.json();
            document.getElementById("resultado").innerText = data.output;
        };
    </script>
</body>
</html>
"""

@app.route("/")
def index():
    return render_template_string(TOOL_PAGE_HTML)

# El formulario de la página realiza un POST a este endpoint
@app.route("/api/diag/ping", methods=["POST"])
def api_ping():
    data = request.get_json()
    host = data.get("host", "")

    try:
        # shell=True permite inyección de comandos
        output = subprocess.check_output(
            f"ping -c 3 {host}", 
            shell=True, 
            stderr=subprocess.STDOUT, 
            timeout=5
        )
        resultado = output.decode("utf-8")
    except subprocess.CalledProcessError as e:
        resultado = e.output.decode("utf-8")
    except subprocess.TimeoutExpired:
        resultado = "ERROR: El comando ha tardado demasiado (Timeout)"
    
    return jsonify({"output": resultado})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=80, debug=True)
