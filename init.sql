-- init.sql
-- Этот файл выполняется ПЕРВЫМ ПРИ ЗАПУСКЕ контейнера
-- Только если volume ПУСТОЙ (data не существует)

-- Дополнительные настройки для основной БД
ALTER DATABASE ${DB_NAME:-mydatabase} SET client_encoding = 'UTF8';

-- Дать права на создание объектов в схеме public (для PostgreSQL 15+)
\c ${DB_NAME:-mydatabase}
GRANT CREATE ON SCHEMA public TO ${DB_USER:-myuser};

-- Создать дополнительные БД если нужно (например, для тестов)
CREATE DATABASE test_${DB_NAME:-mydatabase}
    WITH
    OWNER = ${DB_USER:-myuser}
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';

-- Создать дополнительные пользователи если нужно
-- CREATE USER readonly_user WITH PASSWORD 'readonly_pass';
-- GRANT CONNECT ON DATABASE ${DB_NAME:-mydatabase} TO readonly_user;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;