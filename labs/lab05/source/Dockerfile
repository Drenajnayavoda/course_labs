FROM python:3.11-slim AS builder          # Базовый образ Python, этап сборки зависимостей
WORKDIR /hello                          # Рабочая директория внутри контейнера
COPY requirements.txt .                  # Копируем файл зависимостей отдельно для кеширования
RUN pip install --upgrade pip && pip wheel --wheel-dir=/wheels -r requirements.txt  # обновляем pip, собираем зависимости в wheel-пакеты

FROM python:3.11-slim                     # Финальный минимальный runtime-образ
WORKDIR /hello                            # Рабочая директория приложения

COPY --from=builder /wheels /wheels       # Копируем собранные wheel-пакеты из builder-этапа
COPY requirements.txt .                  # Копируем файл зависимостей
RUN pip install --no-index --find-links=/wheels -r requirements.txt                  # Запрещаем загрузку пакетов из интернета, указываем локальный источник пакетов, устанавливаем зависимости
COPY hello.py .                           # Копируем основной Python-скрипт


ENV PYTHONUNBUFFERED=1                  # Вывод логов без буферизации
CMD ["python", "hello.py"]             # Команда запуска приложения
