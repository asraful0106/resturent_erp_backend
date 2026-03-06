-- 000011_create_orders.down.sql
-- +migrate Down
DROP TABLE IF EXISTS "payment_transactions";
DROP TABLE IF EXISTS "order_promotions";
DROP TABLE IF EXISTS "order_item_addons";
DROP TABLE IF EXISTS "order_items";
DROP TABLE IF EXISTS "orders";
