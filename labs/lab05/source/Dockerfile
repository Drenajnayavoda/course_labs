# Этап 1: сборка зависимостей
FROM python:3.11-slim AS builder

WORKDIR /hello

# Копируем файл с зависимостями
COPY requirements.txt .

# Устанавливаем pip и собираем зависимости в wheel-формате
RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt


# Этап 2: создаем финальный образ
FROM python:3.11-slim

# Устанавливаем необходимые системные библиотеки
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                libgl1 \
                libglib2.0-0 \
                libsm6 \
                libxext6 \
                libxrender1 \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /hello

# Копируем собранные wheel-пакеты из предыдущего этапа
COPY --from=builder /wheels /wheels

# Копируем файл с зависимостями
COPY requirements.txt .

# Устанавливаем зависимости из wheel-файлов
RUN pip install --no-index --find-links=/wheels -r requirements.txt \
        && rm -rf /wheels

# Копируем исходный код приложения
COPY typersteel.py ./

# Переменные окружения для улучшенной работы Python
ENV PYTHONUNBUFFERED=1 \
        SDL_AUDIODRIVER=dummy

# Определяем точку входа и команду по умолчанию
ENTRYPOINT ["python", "-u"]
CMD ["typersteel.py", "AppSec"]
