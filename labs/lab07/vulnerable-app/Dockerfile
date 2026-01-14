FROM python:3.11-slim

# Создадим пользователя non-root
RUN groupadd -r app && useradd -r -g app app

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libjpeg-dev zlib1g-dev \
        libxml2-dev libxslt1-dev wget && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app
RUN chown -R app:app /app

USER app

EXPOSE 8080

ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Простой healthcheck: обращение к / (заменить при необходимости)
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -q -O- http://127.0.0.1:8080/ || exit 1

# Запуск через gunicorn (production)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app", "--workers", "2"]
