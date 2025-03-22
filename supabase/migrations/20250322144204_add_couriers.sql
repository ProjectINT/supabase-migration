BEGIN;

ALTER TABLE orders 
  ADD COLUMN delivery_courier_id UUID REFERENCES users(id) ON DELETE SET NULL,
  ADD COLUMN collection_courier_id UUID REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN orders.delivery_courier_id IS 'Курьер доставки (ссылка на users.id)';
COMMENT ON COLUMN orders.collection_courier_id IS 'Курьер самовывоза (ссылка на users.id)';

COMMIT;