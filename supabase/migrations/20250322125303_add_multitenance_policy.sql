-- Связь "многие ко многим" (пользователь-tenant)
CREATE TABLE user_tenants (
    user_id uuid REFERENCES users(id),
    tenant_id uuid REFERENCES tenants(id)
);

-- Политика для мультиарендности (для orders)
CREATE POLICY "Multi-tenant orders access"
ON orders
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 
        FROM user_tenants 
        WHERE user_tenants.user_id = auth.uid()
        AND user_tenants.tenant_id = orders.tenant_id
    )
);