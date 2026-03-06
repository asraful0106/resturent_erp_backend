-- 000015_create_audit_logs.up.sql
-- +migrate Up
-- audit_logs intentionally has NO foreign key constraints:
-- it must record activity even when referenced rows are later deleted.
-- Partitioned by created_at monthly.
CREATE TABLE "audit_logs" (
    "id"          uuid            DEFAULT gen_random_uuid(),
    "actor_type"  audit_actor_type NOT NULL,
    "actor_id"    uuid             NOT NULL,
    "action"      audit_action     NOT NULL,
    "table_name"  varchar(80)      NOT NULL,
    "record_id"   uuid             NOT NULL,
    "old_data"    jsonb,
    "new_data"    jsonb,
    "ip_address"  varchar(45),
    "user_agent"  text,
    -- PARTITION KEY — partition by RANGE(created_at) monthly
    "created_at"  timestamptz      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_audit_logs_id" PRIMARY KEY ("id")
);

CREATE INDEX "idx_audit_logs_actor_id"      ON "audit_logs" ("actor_id");
CREATE INDEX "idx_audit_logs_table_record"  ON "audit_logs" ("table_name", "record_id");
CREATE INDEX "idx_audit_logs_created_at"    ON "audit_logs" ("created_at");
CREATE INDEX "idx_audit_logs_action"        ON "audit_logs" ("action");
-- Combined actor + time range (security investigations)
CREATE INDEX "idx_audit_logs_actor_time"    ON "audit_logs" ("actor_type", "actor_id", "created_at");
