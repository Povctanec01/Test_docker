-- Создаем пользователя и БД
CREATE USER myuser WITH PASSWORD 'mypassword';
CREATE DATABASE django_db OWNER myuser;

-- Права для PostgreSQL 15+
GRANT ALL ON SCHEMA public TO myuser;
ALTER SCHEMA public OWNER TO myuser;

-- Тестовая таблица
\c django_db
CREATE TABLE IF NOT EXISTS test (id SERIAL PRIMARY KEY, created_at TIMESTAMP DEFAULT NOW());