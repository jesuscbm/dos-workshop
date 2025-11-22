FROM python:3.11-slim

WORKDIR /bot

# 1. Instalamos openssh-server junto con las otras herramientas
RUN apt-get update && apt-get install -y --no-install-recommends \
    iputils-ping \
    curl \
    wget \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# 2. Configuración Vulnerable de SSH
# - Establecemos la contraseña de root a 'root'
RUN echo 'root:root' | chpasswd
# - Permitimos el login directo como root (Deshabilitado por defecto en Debian)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# - (Opcional) Aseguramos que la autenticación por contraseña está activa
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 3. Exponemos ambos puertos (Web y SSH)
EXPOSE 80 22

# 4. Script de arranque en línea
# Iniciamos SSH en segundo plano y luego Gunicorn en primer plano para mantener el contenedor vivo
CMD service ssh start && gunicorn app:app --bind 0.0.0.0:80 --workers 1 --timeout 10
