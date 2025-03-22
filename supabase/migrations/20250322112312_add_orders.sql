CREATE TABLE orders (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    tenant_id uuid REFERENCES tenants(id),  -- Привязка к группе
    user_id uuid REFERENCES users(id),
    product_name text NOT NULL,
    amount decimal NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);