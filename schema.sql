-- 1. Устанавливаем часовой пояс
ALTER DATABASE postgres SET timezone TO 'UTC';

-- 2. Создаём общую схему и роль для неё
CREATE SCHEMA common; -- Общая схема для всех групп
CREATE ROLE common_user NOLOGIN; -- Роль для доступа к общей схеме

-- 3. Создаём группы (NOLOGIN) и схемы
CREATE ROLE group1 NOLOGIN;      -- Группа 1 (компания 1)
CREATE ROLE group2 NOLOGIN;      -- Группа 2 (компания 2)
CREATE SCHEMA group1_schema;     -- Схема для группы 1
CREATE SCHEMA group2_schema;     -- Схема для группы 2

-- 4. Создаём технических пользователей-администраторов групп
CREATE USER group1_admin WITH PASSWORD 'group1password';
CREATE USER group2_admin WITH PASSWORD 'group2password';

-- 5. Назначаем администраторов владельцами схем
ALTER SCHEMA group1_schema OWNER TO group1_admin;
ALTER SCHEMA group2_schema OWNER TO group2_admin;

-- 6. Связываем администраторов с группами
GRANT group1 TO group1_admin;
GRANT group2 TO group2_admin;

-- 7. Настройка привилегий для групп
-- Группа 1
GRANT USAGE ON SCHEMA group1_schema TO group1;
GRANT CREATE, USAGE ON SCHEMA group1_schema TO group1;

-- Группа 2
GRANT USAGE ON SCHEMA group2_schema TO group2;
GRANT CREATE, USAGE ON SCHEMA group2_schema TO group2;

-- 8. Настройка доступа к общей схеме
GRANT USAGE ON SCHEMA common TO common_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA common TO common_user;

-- 9. Связываем группы с общей схемой
GRANT common_user TO group1, group2;

-- 10. Создаём пользователей и назначаем им группы
CREATE USER user1 WITH PASSWORD 'password1';
GRANT group1 TO user1;

CREATE USER user2 WITH PASSWORD 'password2';
GRANT group2 TO user2;

-- 11. Ограничиваем публичный доступ
REVOKE ALL ON SCHEMA group1_schema FROM PUBLIC;
REVOKE ALL ON SCHEMA group2_schema FROM PUBLIC;
REVOKE ALL ON SCHEMA common FROM PUBLIC;