-- 000002_create_enum_types.down.sql
-- +migrate Down
DROP TYPE IF EXISTS "table_session_status";
DROP TYPE IF EXISTS "storage_provider";
DROP TYPE IF EXISTS "promotion_type";
DROP TYPE IF EXISTS "payment_transaction_status";
DROP TYPE IF EXISTS "payment_status";
DROP TYPE IF EXISTS "payment_method";
DROP TYPE IF EXISTS "order_type";
DROP TYPE IF EXISTS "order_status";
DROP TYPE IF EXISTS "notification_status";
DROP TYPE IF EXISTS "notification_event";
DROP TYPE IF EXISTS "notification_channel";
DROP TYPE IF EXISTS "item_status";
DROP TYPE IF EXISTS "inventory_transaction_type";
DROP TYPE IF EXISTS "employee_role";
DROP TYPE IF EXISTS "audit_actor_type";
DROP TYPE IF EXISTS "audit_action";
DROP TYPE IF EXISTS "attendance_status";
DROP TYPE IF EXISTS "approval_status";
