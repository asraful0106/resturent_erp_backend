-- 000011_create_orders.up.sql
-- +migrate Up

-- ─────────────────────────────────────────────
-- orders  (depends on: branches, customers, table_sessions)
-- Partitioned by created_at monthly
-- ─────────────────────────────────────────────
CREATE TABLE "orders" (
    "id"               uuid           DEFAULT gen_random_uuid(),
    "branch_id"        uuid           NOT NULL,
    "customer_id"      uuid,
    "table_session_id" uuid,
    "order_number"     varchar(40)    NOT NULL,
    "type"             order_type     NOT NULL,
    "table_number"     varchar(20),
    "total"            decimal(12,2)  DEFAULT 0,
    "discount_total"   decimal(12,2)  DEFAULT 0,
    "tax_total"        decimal(12,2)  DEFAULT 0,
    "vat_total"        decimal(12,2)  DEFAULT 0,
    "final_total"      decimal(12,2)  NOT NULL,
    "status"           order_status   DEFAULT 'PENDING',
    "payment_status"   payment_status DEFAULT 'PENDING',
    "notes"            text,
    -- PARTITION KEY — partition by RANGE(created_at) monthly
    "created_at"       timestamptz    DEFAULT CURRENT_TIMESTAMP,
    "updated_at"       timestamptz    DEFAULT CURRENT_TIMESTAMP,
    "completed_at"     timestamptz,
    CONSTRAINT "pk_orders_id"                  PRIMARY KEY ("id"),
    CONSTRAINT "uq_order_number_per_branch"    UNIQUE ("branch_id", "order_number"),
    CONSTRAINT "fk_orders_branch_id"           FOREIGN KEY ("branch_id")        REFERENCES "branches" ("id"),
    CONSTRAINT "fk_orders_customer_id"         FOREIGN KEY ("customer_id")      REFERENCES "customers" ("id"),
    CONSTRAINT "fk_orders_table_session_id"    FOREIGN KEY ("table_session_id") REFERENCES "table_sessions" ("id")
);

CREATE INDEX "idx_orders_branch_id"        ON "orders" ("branch_id");
CREATE INDEX "idx_orders_customer_id"      ON "orders" ("customer_id");
CREATE INDEX "idx_orders_table_session_id" ON "orders" ("table_session_id");
CREATE INDEX "idx_orders_status"           ON "orders" ("status");
CREATE INDEX "idx_orders_payment_status"   ON "orders" ("payment_status");
CREATE INDEX "idx_orders_created_at"       ON "orders" ("created_at");
-- Primary dashboard / reporting query
CREATE INDEX "idx_orders_branch_created"   ON "orders" ("branch_id", "created_at");
-- Kitchen display: active orders per branch
CREATE INDEX "idx_orders_branch_status"    ON "orders" ("branch_id", "status")
    WHERE "status" NOT IN ('COMPLETED', 'CANCELLED');

-- ─────────────────────────────────────────────
-- order_items  (depends on: orders, menu_items, item_variants)
-- ─────────────────────────────────────────────
CREATE TABLE "order_items" (
    "id"              uuid          DEFAULT gen_random_uuid(),
    "order_id"        uuid          NOT NULL,
    "menu_item_id"    uuid          NOT NULL,
    "variant_id"      uuid,
    "quantity"        smallint      NOT NULL DEFAULT 1,
    "unit_price"      decimal(12,2) NOT NULL,
    "discount_amount" decimal(12,2) DEFAULT 0,
    "line_total"      decimal(12,2) NOT NULL,
    "notes"           text,
    "created_at"      timestamptz   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_order_items_id"            PRIMARY KEY ("id"),
    CONSTRAINT "fk_order_items_order_id"      FOREIGN KEY ("order_id")     REFERENCES "orders" ("id"),
    CONSTRAINT "fk_order_items_menu_item_id"  FOREIGN KEY ("menu_item_id") REFERENCES "menu_items" ("id"),
    CONSTRAINT "fk_order_items_variant_id"    FOREIGN KEY ("variant_id")   REFERENCES "item_variants" ("id")
);

CREATE INDEX "idx_order_items_order_id"     ON "order_items" ("order_id");
CREATE INDEX "idx_order_items_menu_item_id" ON "order_items" ("menu_item_id");

-- ─────────────────────────────────────────────
-- order_item_addons  (depends on: order_items, addons)
-- ─────────────────────────────────────────────
CREATE TABLE "order_item_addons" (
    "id"            uuid          DEFAULT gen_random_uuid(),
    "order_item_id" uuid          NOT NULL,
    "addon_id"      uuid          NOT NULL,
    "quantity"      smallint      DEFAULT 1,
    "price"         decimal(12,2) NOT NULL,
    "created_at"    timestamptz   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_order_item_addons_id"              PRIMARY KEY ("id"),
    CONSTRAINT "fk_order_item_addons_order_item_id"   FOREIGN KEY ("order_item_id") REFERENCES "order_items" ("id"),
    CONSTRAINT "fk_order_item_addons_addon_id"        FOREIGN KEY ("addon_id")      REFERENCES "addons" ("id")
);

CREATE INDEX "idx_order_item_addons_order_item_id" ON "order_item_addons" ("order_item_id");
CREATE INDEX "idx_order_item_addons_addon_id"      ON "order_item_addons" ("addon_id");

-- ─────────────────────────────────────────────
-- order_promotions  (depends on: orders, promotions)
-- ─────────────────────────────────────────────
CREATE TABLE "order_promotions" (
    "id"              uuid          DEFAULT gen_random_uuid(),
    "order_id"        uuid          NOT NULL,
    "promotion_id"    uuid          NOT NULL,
    "discount_amount" decimal(12,2) NOT NULL,
    "created_at"      timestamptz   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_order_promotions_id"              PRIMARY KEY ("id"),
    CONSTRAINT "fk_order_promotions_order_id"        FOREIGN KEY ("order_id")     REFERENCES "orders" ("id"),
    CONSTRAINT "fk_order_promotions_promotion_id"    FOREIGN KEY ("promotion_id") REFERENCES "promotions" ("id")
);

CREATE INDEX "idx_order_promotions_order_id"     ON "order_promotions" ("order_id");
CREATE INDEX "idx_order_promotions_promotion_id" ON "order_promotions" ("promotion_id");

-- ─────────────────────────────────────────────
-- payment_transactions  (depends on: orders)
-- ─────────────────────────────────────────────
CREATE TABLE "payment_transactions" (
    "id"         uuid                     DEFAULT gen_random_uuid(),
    "order_id"   uuid                     NOT NULL,
    "method"     payment_method           NOT NULL,
    "status"     payment_transaction_status NOT NULL DEFAULT 'PENDING',
    "amount"     decimal(12,2)             NOT NULL,
    "reference"  varchar(200),
    "note"       text,
    "created_at" timestamptz               DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz               DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_payment_transactions_id"        PRIMARY KEY ("id"),
    CONSTRAINT "fk_payment_transactions_order_id"  FOREIGN KEY ("order_id") REFERENCES "orders" ("id")
);

CREATE INDEX "idx_payment_transactions_order_id"   ON "payment_transactions" ("order_id");
CREATE INDEX "idx_payment_transactions_status"     ON "payment_transactions" ("status");
CREATE INDEX "idx_payment_transactions_created_at" ON "payment_transactions" ("created_at");
CREATE INDEX "idx_payment_transactions_method"     ON "payment_transactions" ("method");
