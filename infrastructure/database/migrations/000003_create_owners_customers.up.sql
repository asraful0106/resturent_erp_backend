-- 000003_create_owners_customers.up.sql

-- +migrate Up

-- ─────────────────────────────────────────────
-- owners  (root: no foreign key dependencies)
-- ─────────────────────────────────────────────
CREATE TABLE "owners" (
    "id"            uuid        NOT NULL DEFAULT gen_random_uuid(),
    "name"          varchar(160) NOT NULL,
    "email"         varchar(320) NOT NULL,
    "phone"         varchar(30),
    "password_hash" text        NOT NULL,
    "role" user_role NOT NULL DEFAULT 'USER',
    -- soft delete
    "deleted_at"    timestamptz,
    "created_at"    timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_owners_id"    PRIMARY KEY ("id"),
    CONSTRAINT "uq_owners_email" UNIQUE ("email")
);

-- ─────────────────────────────────────────────
-- customers  (root: no foreign key dependencies)
-- ─────────────────────────────────────────────
CREATE TABLE "customers" (
    "id"         uuid        DEFAULT gen_random_uuid(),
    "name"       varchar(160),
    "phone"      varchar(30)  NOT NULL,
    "email"      varchar(320),
    -- soft delete
    "deleted_at" timestamptz,
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_customers_id"    PRIMARY KEY ("id"),
    CONSTRAINT "uq_customers_phone" UNIQUE ("phone")
);

-- Indexes
CREATE INDEX "idx_customers_email"      ON "customers" ("email") WHERE "email" IS NOT NULL;
CREATE INDEX "idx_customers_deleted_at" ON "customers" ("deleted_at") WHERE "deleted_at" IS NOT NULL;
