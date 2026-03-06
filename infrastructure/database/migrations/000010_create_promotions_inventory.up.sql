-- 000010_create_promotions_inventory.up.sql
-- +migrate Up

-- ─────────────────────────────────────────────
-- promotions  (depends on: branches)
-- ─────────────────────────────────────────────
CREATE TABLE "promotions" (
    "id"          uuid           DEFAULT gen_random_uuid(),
    "branch_id"   uuid           NOT NULL,
    "code"        varchar(60),
    "description" text,
    "type"        promotion_type NOT NULL,
    "value"       decimal(12,2)  NOT NULL,
    "min_order"   decimal(12,2),
    -- null = unlimited
    "max_uses"    int,
    "used_count"  int            NOT NULL DEFAULT 0,
    "starts_at"   timestamptz,
    "expires_at"  timestamptz,
    "is_active"   boolean        DEFAULT true,
    "created_at"  timestamptz    DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  timestamptz    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_promotions_id"              PRIMARY KEY ("id"),
    CONSTRAINT "uq_promo_code_per_branch"      UNIQUE ("branch_id", "code"),
    CONSTRAINT "fk_promotions_branch_id"       FOREIGN KEY ("branch_id") REFERENCES "branches" ("id")
);

CREATE INDEX "idx_promotions_branch_id"  ON "promotions" ("branch_id");
CREATE INDEX "idx_promotions_is_active"  ON "promotions" ("branch_id", "is_active");
-- Partial index: only index active promos within their validity window
CREATE INDEX "idx_promotions_active_window" ON "promotions" ("branch_id", "expires_at")
    WHERE "is_active" = true;

-- ─────────────────────────────────────────────
-- inventory_items  (depends on: branches)
-- ─────────────────────────────────────────────
CREATE TABLE "inventory_items" (
    "id"            uuid         DEFAULT gen_random_uuid(),
    "branch_id"     uuid         NOT NULL,
    "name"          varchar(200) NOT NULL,
    "unit"          varchar(40),
    "current_stock" decimal(12,3) DEFAULT 0,
    "min_stock"     decimal(12,3),
    -- soft delete
    "deleted_at"    timestamptz,
    "created_at"    timestamptz  DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    timestamptz  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_inventory_items_id"           PRIMARY KEY ("id"),
    CONSTRAINT "uq_inventory_name_per_branch"    UNIQUE ("branch_id", "name"),
    CONSTRAINT "fk_inventory_items_branch_id"    FOREIGN KEY ("branch_id") REFERENCES "branches" ("id")
);

CREATE INDEX "idx_inventory_items_branch_id"   ON "inventory_items" ("branch_id");
-- Alert query: items at or below minimum stock
CREATE INDEX "idx_inventory_items_low_stock"   ON "inventory_items" ("branch_id", "current_stock", "min_stock")
    WHERE "deleted_at" IS NULL;
CREATE INDEX "idx_inventory_items_deleted_at"  ON "inventory_items" ("deleted_at") WHERE "deleted_at" IS NOT NULL;

-- ─────────────────────────────────────────────
-- inventory_transactions  (depends on: inventory_items)
-- Partitioned by created_at monthly (declare RANGE partition hint via comment)
-- ─────────────────────────────────────────────
CREATE TABLE "inventory_transactions" (
    "id"              uuid                     DEFAULT gen_random_uuid(),
    "inventory_id"    uuid                     NOT NULL,
    "type"            inventory_transaction_type NOT NULL,
    "quantity"        decimal(12,3)             NOT NULL,
    "unit_price"      decimal(12,2),
    "total_amount"    decimal(12,2),
    "approval_status" approval_status           DEFAULT 'PENDING',
    "note"            text,
    -- PARTITION KEY — partition by RANGE(created_at) monthly
    "created_at"      timestamptz               DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_inventory_transactions_id"         PRIMARY KEY ("id"),
    CONSTRAINT "fk_inventory_transactions_inventory_id" FOREIGN KEY ("inventory_id") REFERENCES "inventory_items" ("id")
);

CREATE INDEX "idx_inventory_transactions_inventory_id" ON "inventory_transactions" ("inventory_id");
CREATE INDEX "idx_inventory_transactions_type"         ON "inventory_transactions" ("type");
CREATE INDEX "idx_inventory_transactions_created_at"   ON "inventory_transactions" ("created_at");
-- Approval workflow queries
CREATE INDEX "idx_inventory_transactions_approval"     ON "inventory_transactions" ("approval_status")
    WHERE "approval_status" = 'PENDING';
