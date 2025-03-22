-- Пользователь может добавлять заказы только в свой тенант
CREATE POLICY "Insert orders for own tenant" 
ON orders
FOR INSERT
TO authenticated
WITH CHECK (
    tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid())
);