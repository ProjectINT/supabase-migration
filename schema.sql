alter database postgres
set timezone to 'UTC';

-- 1. Создание общих ролей и схемы
CREATE SCHEMA common; -- Общая схема
CREATE ROLE common_user NOLOGIN; -- Роль для доступа к общей схеме

-- 2. Создание групп и их схем
CREATE ROLE group1 NOLOGIN;      -- Компания 1
CREATE SCHEMA group1_schema;     -- Схема для группы 1
CREATE ROLE group2 NOLOGIN;      -- Компания 2
CREATE SCHEMA group2_schema;     -- Схема для группы 2

-- 3. Настройка привилегий для групп
-- Для Group1
GRANT USAGE ON SCHEMA group1_schema TO group1;

GRANT CREATE, USAGE ON SCHEMA group1_schema TO group1;
ALTER SCHEMA group1_schema OWNER TO group1;

-- Для Group2
GRANT USAGE ON SCHEMA group2_schema TO group2;
GRANT CREATE, USAGE ON SCHEMA group2_schema TO group2;
ALTER SCHEMA group2_schema OWNER TO group2;

-- 4. Настройка доступа к общей схеме
GRANT USAGE ON SCHEMA common TO common_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA common TO common_user;

-- 5. Связывание групп с общей схемой
GRANT common_user TO group1, group2;

-- 6. Создание конкретных пользователей
CREATE USER user1 WITH PASSWORD 'password1';
GRANT group1 TO user1;

CREATE USER user2 WITH PASSWORD 'password2';
GRANT group2 TO user2;

-- 7. Отзыв прав у PUBLIC
REVOKE ALL ON SCHEMA group1_schema FROM PUBLIC;
REVOKE ALL ON SCHEMA group2_schema FROM PUBLIC;
REVOKE ALL ON SCHEMA common FROM PUBLIC;