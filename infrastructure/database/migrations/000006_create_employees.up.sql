-- 000006_create_employees.up.sql

-- +migrate Up
CREATE TABLE "employees" (
    "id"             uuid          DEFAULT gen_random_uuid(),
    "branch_id"      uuid          NOT NULL,
    "name"           varchar(160)  NOT NULL,
    "email"          varchar(320),
    "phone"          varchar(30),
    "password_hash"  text,
    "role"           employee_role NOT NULL,
    "salary_monthly" decimal(12,2),
    "nid"            varchar(50),
    "join_date"      date,
    "is_active"      boolean       NOT NULL DEFAULT true,
    -- soft delete
    "deleted_at"     timestamptz,
    "created_at"     timestamptz   DEFAULT CURRENT_TIMESTAMP,
    "updated_at"     timestamptz   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_employees_id"       PRIMARY KEY ("id"),
    CONSTRAINT "uq_employees_email"    UNIQUE ("email"),
    CONSTRAINT "uq_employees_phone"    UNIQUE ("phone"),
    CONSTRAINT "fk_employees_branch_id" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id")
);

-- Indexes
CREATE INDEX "idx_employees_branch_id"  ON "employees" ("branch_id");
CREATE INDEX "idx_employees_role"       ON "employees" ("role");
CREATE INDEX "idx_employees_is_active"  ON "employees" ("branch_id", "is_active");
CREATE INDEX "idx_employees_deleted_at" ON "employees" ("deleted_at") WHERE "deleted_at" IS NOT NULL;
