-- 000001_enable_uuid_extension.down.sql
-- +migrate Down
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS "pgcrypto";
