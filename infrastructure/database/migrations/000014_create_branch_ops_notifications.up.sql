-- 000014_create_branch_ops_notifications.up.sql
-- +migrate Up

-- ─────────────────────────────────────────────
-- branch_operating_hours  (depends on: branches)
-- ─────────────────────────────────────────────
CREATE TABLE "branch_operating_hours" (
    "id"          uuid       DEFAULT gen_random_uuid(),
    "branch_id"   uuid       NOT NULL,
    -- CHECK (day_of_week BETWEEN 0 AND 6)
    "day_of_week" smallint   NOT NULL CHECK ("day_of_week" BETWEEN 0 AND 6),
    "open_time"   time       NOT NULL,
    "close_time"  time       NOT NULL,
    -- true = branch closed this day
    "is_closed"   boolean    NOT NULL DEFAULT false,
    "created_at"  timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  timestamptz DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_branch_operating_hours_id"              PRIMARY KEY ("id"),
    CONSTRAINT "uq_operating_hours_per_branch_day"         UNIQUE ("branch_id", "day_of_week"),
    CONSTRAINT "fk_branch_operating_hours_branch_id"       FOREIGN KEY ("branch_id") REFERENCES "branches" ("id")
);

CREATE INDEX "idx_operating_hours_branch_id" ON "branch_operating_hours" ("branch_id");

-- ─────────────────────────────────────────────
-- notification_logs  (depends on: branches)
-- Partitioned by created_at monthly
-- ─────────────────────────────────────────────
CREATE TABLE "notification_logs" (
    "id"             uuid                 DEFAULT gen_random_uuid(),
    "branch_id"      uuid,
    -- CUSTOMER or EMPLOYEE
    "recipient_type" varchar(20)          NOT NULL,
    "recipient_id"   uuid                 NOT NULL,
    "event"          notification_event   NOT NULL,
    "channel"        notification_channel NOT NULL,
    "status"         notification_status  NOT NULL DEFAULT 'PENDING',
    "subject"        varchar(255),
    "body"           text,
    "provider_ref"   varchar(200),
    "error"          text,
    "sent_at"        timestamptz,
    -- PARTITION KEY — partition by RANGE(created_at) monthly
    "created_at"     timestamptz          DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "pk_notification_logs_id"       PRIMARY KEY ("id"),
    CONSTRAINT "fk_notification_logs_branch_id" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id")
);

CREATE INDEX "idx_notif_recipient"   ON "notification_logs" ("recipient_type", "recipient_id");
CREATE INDEX "idx_notif_branch_id"   ON "notification_logs" ("branch_id");
CREATE INDEX "idx_notif_event"       ON "notification_logs" ("event");
CREATE INDEX "idx_notif_status"      ON "notification_logs" ("status");
CREATE INDEX "idx_notif_created_at"  ON "notification_logs" ("created_at");
-- Retry queue: only pending/failed notifications
CREATE INDEX "idx_notif_retry_queue" ON "notification_logs" ("status", "created_at")
    WHERE "status" IN ('PENDING', 'FAILED');
