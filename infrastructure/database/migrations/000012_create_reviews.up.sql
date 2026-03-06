-- 000012_create_reviews.up.sql
-- +migrate Up
CREATE TABLE "reviews" (
    "id"          uuid      DEFAULT gen_random_uuid(),
    "order_id"    uuid,
    "customer_id" uuid,
    -- CHECK (rating BETWEEN 1 AND 5)
    "rating"      smallint  CHECK ("rating" BETWEEN 1 AND 5),
    "comment"     text,
    "created_at"  timestamptz DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_reviews_id"                   PRIMARY KEY ("id"),
    CONSTRAINT "uq_review_per_order_customer"    UNIQUE ("order_id", "customer_id"),
    CONSTRAINT "fk_reviews_order_id"             FOREIGN KEY ("order_id")    REFERENCES "orders" ("id"),
    CONSTRAINT "fk_reviews_customer_id"          FOREIGN KEY ("customer_id") REFERENCES "customers" ("id")
);

CREATE INDEX "idx_reviews_customer_id" ON "reviews" ("customer_id");
CREATE INDEX "idx_reviews_order_id"    ON "reviews" ("order_id");
CREATE INDEX "idx_reviews_rating"      ON "reviews" ("rating");
