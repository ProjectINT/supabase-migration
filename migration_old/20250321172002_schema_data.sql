DO $$ 
DECLARE 
    schema_name TEXT;
BEGIN
    -- Цикл по всем нужным схемам
    FOR schema_name IN SELECT nspname FROM pg_namespace WHERE nspname IN ('group1_schema', 'group2_schema')
    LOOP
        -- Создаём таблицу orders
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.orders (
                id SERIAL PRIMARY KEY,
                customer_name TEXT NOT NULL,
                total_price DECIMAL(10,2) NOT NULL,
                created_at TIMESTAMP DEFAULT now(),
                CONSTRAINT fk_vehicle FOREIGN KEY (vehicle_id),
                  REFERENCES %I.orders(id) ON DELETE RESTRICT
            );
        ', schema_name);

        -- Создаём таблицу vehicles (с обязательной FK-связью с orders)
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I.vehicles (
                id SERIAL PRIMARY KEY,
                order_id INT NOT NULL,
                model TEXT NOT NULL,
                price_per_day DECIMAL(10,2) NOT NULL
            );
        ', schema_name, schema_name);
    END LOOP;
END $$;