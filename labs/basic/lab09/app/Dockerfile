FROM python:3.12-slim
WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libjpeg-dev zlib1g-dev \
        libxml2-dev libxslt1-dev curl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app", "--workers", "2"]
