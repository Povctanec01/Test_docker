FROM python:3.12-slim as builder

WORKDIR /app

# Установка зависимостей для сборки
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем зависимости
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --user --no-cache-dir -r requirements.txt

# Финальный образ
FROM python:3.12-slim

WORKDIR /app

# Установка runtime зависимостей
RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Копируем Python пакеты из builder
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Создаем непривилегированного пользователя
RUN useradd -m -u 1000 django && \
    chown -R django:django /app
USER django

# Настройки Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Копируем код проекта
COPY --chown=django:django . .

# Создаем директории для статики и медиа
RUN mkdir -p staticfiles media && \
    chown django:django staticfiles media

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "Test_docker.wsgi:application"]