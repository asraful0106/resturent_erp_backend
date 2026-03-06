-- 000004_create_restaurants.up.sql

-- +migrate Up
CREATE TABLE "restaurants" (
    "id"         uuid        NOT NULL DEFAULT gen_random_uuid(),
    "owner_id"   uuid        NOT NULL,
    "name"       varchar(200) NOT NULL,
    "brand_slug" varchar(120),
    -- soft delete
    "deleted_at" timestamptz,
    "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_restaurants_id"         PRIMARY KEY ("id"),
    CONSTRAINT "uq_restaurants_brand_slug" UNIQUE ("brand_slug"),
    CONSTRAINT "fk_restaurants_owner_id"   FOREIGN KEY ("owner_id") REFERENCES "owners" ("id")
);

-- Indexes
CREATE INDEX "idx_restaurants_owner_id"   ON "restaurants" ("owner_id");
CREATE INDEX "idx_restaurants_deleted_at" ON "restaurants" ("deleted_at") WHERE "deleted_at" IS NOT NULL;
