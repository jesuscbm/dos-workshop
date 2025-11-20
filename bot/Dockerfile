FROM python:3.11-slim

WORKDIR /bot

RUN apt-get update && apt-get install -y --no-install-recommends \
    iputils-ping \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:80", "--workers", "1", "--timeout", "10"]
