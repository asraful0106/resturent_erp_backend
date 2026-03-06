-- 000013_create_employee_records.up.sql
-- +migrate Up

-- ─────────────────────────────────────────────
-- employee_attendance  (depends on: employees)
-- ─────────────────────────────────────────────
CREATE TABLE "employee_attendance" (
    "id"          uuid              DEFAULT gen_random_uuid(),
    "employee_id" uuid              NOT NULL,
    "date"        date              NOT NULL,
    "status"      attendance_status NOT NULL,
    "check_in"    timestamptz,
    "check_out"   timestamptz,
    "created_at"  timestamptz       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_employee_attendance_id"            PRIMARY KEY ("id"),
    CONSTRAINT "uq_attendance_per_employee_day"       UNIQUE ("employee_id", "date"),
    CONSTRAINT "fk_employee_attendance_employee_id"   FOREIGN KEY ("employee_id") REFERENCES "employees" ("id")
);

CREATE INDEX "idx_employee_attendance_employee_id" ON "employee_attendance" ("employee_id");
CREATE INDEX "idx_employee_attendance_date"        ON "employee_attendance" ("date");
-- Range queries: attendance report for a period
CREATE INDEX "idx_employee_attendance_emp_date"    ON "employee_attendance" ("employee_id", "date");

-- ─────────────────────────────────────────────
-- employee_payments  (depends on: employees)
-- ─────────────────────────────────────────────
CREATE TABLE "employee_payments" (
    "id"              uuid            DEFAULT gen_random_uuid(),
    "employee_id"     uuid            NOT NULL,
    "period_from"     date            NOT NULL,
    "period_to"       date            NOT NULL,
    "amount"          decimal(12,2)   NOT NULL,
    "bonus"           decimal(12,2)   DEFAULT 0,
    "deduction"       decimal(12,2)   DEFAULT 0,
    "approval_status" approval_status DEFAULT 'PENDING',
    "paid_at"         timestamptz,
    "created_at"      timestamptz     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_employee_payments_id"               PRIMARY KEY ("id"),
    CONSTRAINT "uq_payment_per_employee_period"        UNIQUE ("employee_id", "period_from", "period_to"),
    CONSTRAINT "fk_employee_payments_employee_id"      FOREIGN KEY ("employee_id") REFERENCES "employees" ("id")
);

CREATE INDEX "idx_employee_payments_employee_id"    ON "employee_payments" ("employee_id");
CREATE INDEX "idx_employee_payments_period"         ON "employee_payments" ("employee_id", "period_from", "period_to");
CREATE INDEX "idx_employee_payments_approval"       ON "employee_payments" ("approval_status")
    WHERE "approval_status" = 'PENDING';
