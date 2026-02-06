# Используем официальный Python образ
FROM python:3.11-slim

# Устанавливаем переменные окружения
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем системные зависимости
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Poetry (если используете) или напрямую pip
COPY requirements.txt /app/

# Устанавливаем зависимости Python
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Копируем проект
COPY . /app/

# Создаем статическую папку
RUN mkdir -p /app/static /app/media

# Создаем пользователя без привилегий
RUN adduser --disabled-password --gecos '' django-user
RUN chown -R django-user:django-user /app
RUN chmod -R 755 /app/static
USER django-user

# Команда для запуска
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "your_project.wsgi:application"]