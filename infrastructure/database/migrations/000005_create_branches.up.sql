-- 000005_create_branches.up.sql
-- NOTE: branch_setting is created first because branches has a FK that references it.
-- The FK direction is: branches.id → branch_setting.branch_id (1-to-1, branch owns its setting).

-- +migrate Up

-- ─────────────────────────────────────────────
-- branch_setting
-- ─────────────────────────────────────────────
CREATE TABLE "branch_setting" (
    "id"         uuid         DEFAULT gen_random_uuid(),
    "branch_id"  uuid         NOT NULL,
    -- ISO 4217 currency code
    "currency"   varchar(10)  NOT NULL DEFAULT 'BDT',
    -- IANA timezone
    "timezone"   varchar(60)  NOT NULL DEFAULT 'Asia/Dhaka',
    "is_vat"     boolean      NOT NULL DEFAULT false,
    "vat"        decimal(12,2),
    "is_tax"     boolean      NOT NULL DEFAULT false,
    "tax"        decimal(12,2),
    "created_at" timestamptz  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_branch_setting_id"       PRIMARY KEY ("id"),
    CONSTRAINT "uq_branch_setting_branch_id" UNIQUE ("branch_id")
);

-- ─────────────────────────────────────────────
-- branches  (depends on: restaurants, branch_setting)
-- ─────────────────────────────────────────────
CREATE TABLE "branches" (
    "id"            uuid        NOT NULL DEFAULT gen_random_uuid(),
    "restaurant_id" uuid        NOT NULL,
    "name"          varchar(160) NOT NULL,
    "address"       text,
    "lat"           decimal(9,6),
    "lng"           decimal(9,6),
    "phone"         varchar(30),
    "email"         varchar(320),
    "is_active"     boolean     DEFAULT true,
    -- soft delete
    "deleted_at"    timestamptz,
    "created_at"    timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_branches_id"                  PRIMARY KEY ("id"),
    CONSTRAINT "uq_branch_name_per_restaurant"   UNIQUE ("restaurant_id", "name"),
    CONSTRAINT "fk_branches_restaurant_id"       FOREIGN KEY ("restaurant_id") REFERENCES "restaurants" ("id"),
    CONSTRAINT "fk_branches_id_branch_setting"   FOREIGN KEY ("id") REFERENCES "branch_setting" ("branch_id")
);

-- Indexes
CREATE INDEX "idx_branches_restaurant_id" ON "branches" ("restaurant_id");
CREATE INDEX "idx_branches_is_active"     ON "branches" ("is_active");
CREATE INDEX "idx_branches_deleted_at"    ON "branches" ("deleted_at") WHERE "deleted_at" IS NOT NULL;
