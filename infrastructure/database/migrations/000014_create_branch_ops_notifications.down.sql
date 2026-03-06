-- 000014_create_branch_ops_notifications.down.sql
-- +migrate Down
DROP TABLE IF EXISTS "notification_logs";
DROP TABLE IF EXISTS "branch_operating_hours";
