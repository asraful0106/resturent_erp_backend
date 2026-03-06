-- 000001_enable_uuid_extension.up.sql
-- Enable pgcrypto for gen_random_uuid() (available in PostgreSQL 13+ core, but kept for compatibility)
-- +migrate Up
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enable uuid-ossp as a fallback / for uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
