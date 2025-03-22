-- Таблица групп (тенантов)
CREATE TABLE tenants (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    name text NOT NULL
);

-- Таблица пользователей
CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    email text NOT NULL UNIQUE,
    tenant_id uuid REFERENCES tenants(id),  -- Ссылка на группу
    role text NOT NULL DEFAULT 'DRIVER',    -- admin, user
    created_at timestamp with time zone DEFAULT now()
);