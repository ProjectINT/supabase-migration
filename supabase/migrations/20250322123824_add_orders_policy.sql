-- Каждый пользователь видит только заказы своего тенанта
CREATE POLICY "Tenant-based orders access" 
ON orders
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM users 
        WHERE users.id = auth.uid()
        AND users.tenant_id = orders.tenant_id
    )
);