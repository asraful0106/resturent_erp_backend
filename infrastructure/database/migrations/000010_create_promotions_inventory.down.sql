-- 000010_create_promotions_inventory.down.sql
-- +migrate Down
DROP TABLE IF EXISTS "inventory_transactions";
DROP TABLE IF EXISTS "inventory_items";
DROP TABLE IF EXISTS "promotions";
