-- 000007_create_table_sessions.up.sql
-- +migrate Up
CREATE TABLE "table_sessions" (
    "id"           uuid                 DEFAULT gen_random_uuid(),
    "branch_id"    uuid                 NOT NULL,
    "table_number" varchar(20)          NOT NULL,
    "status"       table_session_status NOT NULL DEFAULT 'OPEN',
    -- number of guests seated
    "covers"       smallint,
    "opened_at"    timestamptz          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "closed_at"    timestamptz,
    "created_by"   uuid,
    "created_at"   timestamptz          DEFAULT CURRENT_TIMESTAMP,
    "updated_at"   timestamptz          DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_table_sessions_id"         PRIMARY KEY ("id"),
    CONSTRAINT "fk_table_sessions_branch_id"  FOREIGN KEY ("branch_id")  REFERENCES "branches" ("id"),
    CONSTRAINT "fk_table_sessions_created_by" FOREIGN KEY ("created_by") REFERENCES "employees" ("id")
);

-- Indexes
CREATE INDEX "idx_table_sessions_branch_id"    ON "table_sessions" ("branch_id");
CREATE INDEX "idx_table_sessions_status"       ON "table_sessions" ("status");
-- Fast lookup: find open session for a specific table in a branch
CREATE INDEX "idx_table_sessions_open_lookup"  ON "table_sessions" ("branch_id", "table_number", "status");
CREATE INDEX "idx_table_sessions_opened_at"    ON "table_sessions" ("branch_id", "opened_at");
