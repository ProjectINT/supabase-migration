ALTER TABLE orders
ALTER COLUMN amount TYPE text
USING amount::text;