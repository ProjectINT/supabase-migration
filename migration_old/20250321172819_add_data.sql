DO $$ 
DECLARE 
    schema_name TEXT;
    order_id INT;
BEGIN
    -- Цикл по всем нужным схемам
    FOR schema_name IN SELECT nspname FROM pg_namespace WHERE nspname IN ('group1_schema', 'group2_schema')
    LOOP
        -- Добавляем 3 заказа
        FOR order_id IN
            SELECT nextval(pg_get_serial_sequence(schema_name || '.orders', 'id'))
        LOOP
            EXECUTE format('
                INSERT INTO %I.orders (customer_name, total_price, created_at)
                VALUES 
                (''John Doe'', 500.00, now()),
                (''Alice Smith'', 1200.50, now()),
                (''Bob Johnson'', 750.75, now())
                RETURNING id
            ', schema_name) INTO order_id;

            -- Добавляем 3 машины, привязанные к созданным заказам
            EXECUTE format('
                INSERT INTO %I.vehicles (order_id, model, price_per_day)
                VALUES 
                (%s, ''Porsche 911'', 200.00),
                (%s, ''Lamborghini Huracan'', 350.00),
                (%s, ''Ferrari 488'', 400.00)
            ', schema_name, order_id, order_id, order_id);
        END LOOP;
    END LOOP;
END $$;