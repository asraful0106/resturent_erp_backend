-- 000008_create_menu.up.sql

-- ─────────────────────────────────────────────
-- menu_categories  (depends on: branches)
-- ─────────────────────────────────────────────
-- +migrate Up
CREATE TABLE "menu_categories" (
    "id"            uuid        DEFAULT gen_random_uuid(),
    "branch_id"     uuid        NOT NULL,
    "name"          varchar(120) NOT NULL,
    "display_order" int         DEFAULT 0,
    -- soft delete
    "deleted_at"    timestamptz,
    "created_at"    timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    timestamptz DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_menu_categories_id"              PRIMARY KEY ("id"),
    CONSTRAINT "uq_category_name_per_branch"        UNIQUE ("branch_id", "name"),
    CONSTRAINT "fk_menu_categories_branch_id"       FOREIGN KEY ("branch_id") REFERENCES "branches" ("id")
);

CREATE INDEX "idx_menu_categories_branch_id"   ON "menu_categories" ("branch_id");
CREATE INDEX "idx_menu_categories_display_ord" ON "menu_categories" ("branch_id", "display_order");
CREATE INDEX "idx_menu_categories_deleted_at"  ON "menu_categories" ("deleted_at") WHERE "deleted_at" IS NOT NULL;

-- ─────────────────────────────────────────────
-- menu_items  (depends on: branches, menu_categories)
-- ─────────────────────────────────────────────
CREATE TABLE "menu_items" (
    "id"           uuid        DEFAULT gen_random_uuid(),
    "branch_id"    uuid        NOT NULL,
    "category_id"  uuid        NOT NULL,
    "name"         varchar(200) NOT NULL,
    "slug"         varchar(200),
    "description"  text,
    "base_price"   decimal(12,2) NOT NULL,
    "status"       item_status  DEFAULT 'AVAILABLE',
    -- CHECK (prep_time_min >= 0)
    "prep_time_min" smallint    CHECK ("prep_time_min" >= 0),
    "is_active"    boolean      NOT NULL DEFAULT true,
    -- soft delete
    "deleted_at"   timestamptz,
    "created_at"   timestamptz  DEFAULT CURRENT_TIMESTAMP,
    "updated_at"   timestamptz  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_menu_items_id"               PRIMARY KEY ("id"),
    CONSTRAINT "uq_item_slug_per_branch"        UNIQUE ("branch_id", "slug"),
    CONSTRAINT "fk_menu_items_branch_id"        FOREIGN KEY ("branch_id")   REFERENCES "branches" ("id"),
    CONSTRAINT "fk_menu_items_category_id"      FOREIGN KEY ("category_id") REFERENCES "menu_categories" ("id")
);

CREATE INDEX "idx_menu_items_branch_id"    ON "menu_items" ("branch_id");
CREATE INDEX "idx_menu_items_category_id"  ON "menu_items" ("category_id");
CREATE INDEX "idx_menu_items_status"       ON "menu_items" ("status");
-- Listing active items by branch + category (most common query)
CREATE INDEX "idx_menu_items_branch_cat_active" ON "menu_items" ("branch_id", "category_id", "is_active");
CREATE INDEX "idx_menu_items_deleted_at"   ON "menu_items" ("deleted_at") WHERE "deleted_at" IS NOT NULL;
