-- 000009_create_menu_extras.up.sql
-- +migrate Up

-- ─────────────────────────────────────────────
-- item_variants  (depends on: menu_items)
-- ─────────────────────────────────────────────
CREATE TABLE "item_variants" (
    "id"            uuid         DEFAULT gen_random_uuid(),
    "item_id"       uuid         NOT NULL,
    "name"          varchar(120) NOT NULL,
    "price_offset"  decimal(12,2) DEFAULT 0,
    "display_order" int          DEFAULT 0,
    "created_at"    timestamptz  DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    timestamptz  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_item_variants_id"          PRIMARY KEY ("id"),
    CONSTRAINT "uq_variant_name_per_item"     UNIQUE ("item_id", "name"),
    CONSTRAINT "fk_item_variants_item_id"     FOREIGN KEY ("item_id") REFERENCES "menu_items" ("id")
);

CREATE INDEX "idx_item_variants_item_id"      ON "item_variants" ("item_id");
CREATE INDEX "idx_item_variants_display_order" ON "item_variants" ("item_id", "display_order");

-- ─────────────────────────────────────────────
-- menu_images  (depends on: menu_items)
-- ─────────────────────────────────────────────
CREATE TABLE "menu_images" (
    "id"         uuid             DEFAULT gen_random_uuid(),
    "item_id"    uuid,
    "url"        varchar(500)     NOT NULL,
    "provider"   storage_provider NOT NULL,
    "created_at" timestamptz      DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz      DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_menu_images_id"     PRIMARY KEY ("id"),
    CONSTRAINT "fk_menu_images_item_id" FOREIGN KEY ("item_id") REFERENCES "menu_items" ("id")
);

CREATE INDEX "idx_menu_images_item_id" ON "menu_images" ("item_id");

-- ─────────────────────────────────────────────
-- addon_groups  (depends on: menu_items)
-- ─────────────────────────────────────────────
CREATE TABLE "addon_groups" (
    "id"          uuid        DEFAULT gen_random_uuid(),
    "item_id"     uuid,
    "name"        varchar(120) NOT NULL,
    "min_choices" smallint    DEFAULT 0,
    "max_choices" smallint,
    "created_at"  timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  timestamptz DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_addon_groups_id"             PRIMARY KEY ("id"),
    CONSTRAINT "uq_addongroup_name_per_item"    UNIQUE ("item_id", "name"),
    CONSTRAINT "fk_addon_groups_item_id"        FOREIGN KEY ("item_id") REFERENCES "menu_items" ("id")
);

CREATE INDEX "idx_addon_groups_item_id" ON "addon_groups" ("item_id");

-- ─────────────────────────────────────────────
-- addons  (depends on: addon_groups)
-- ─────────────────────────────────────────────
CREATE TABLE "addons" (
    "id"         uuid        DEFAULT gen_random_uuid(),
    "group_id"   uuid        NOT NULL,
    "name"       varchar(160) NOT NULL,
    "price"      decimal(12,2) NOT NULL,
    "status"     item_status  DEFAULT 'AVAILABLE',
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_addons_id"              PRIMARY KEY ("id"),
    CONSTRAINT "uq_addon_name_per_group"   UNIQUE ("group_id", "name"),
    CONSTRAINT "fk_addons_group_id"        FOREIGN KEY ("group_id") REFERENCES "addon_groups" ("id")
);

CREATE INDEX "idx_addons_group_id" ON "addons" ("group_id");
CREATE INDEX "idx_addons_status"   ON "addons" ("status");
