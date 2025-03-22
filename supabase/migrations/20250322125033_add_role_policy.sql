-- Админы могут видеть все заказы своего тенанта
CREATE POLICY "Admins can see all orders"
ON orders
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 
        FROM users 
        WHERE users.id = auth.uid()
        AND users.tenant_id = orders.tenant_id
        AND users.role = 'ADMIN'
    )
);