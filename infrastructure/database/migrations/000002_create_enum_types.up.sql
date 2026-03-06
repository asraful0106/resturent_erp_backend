-- 000002_create_enum_types.up.sql

-- +migrate Up
CREATE TYPE "approval_status"              AS ENUM ('PENDING', 'APPROVED', 'REJECTED');
CREATE TYPE "attendance_status"            AS ENUM ('PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'VACATION', 'SICK_LEAVE');
CREATE TYPE "audit_action"                 AS ENUM ('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'APPROVE', 'REJECT');
CREATE TYPE "audit_actor_type"             AS ENUM ('OWNER', 'EMPLOYEE', 'SYSTEM');
CREATE TYPE "user_role"                AS ENUM ('SUPER_ADMIN', 'ADMIN', 'USER');
CREATE TYPE "employee_role"                AS ENUM ('OWNER', 'MANAGER', 'CHEF', 'CASHIER', 'WAITER', 'DELIVERY', 'HELPER');
CREATE TYPE "inventory_transaction_type"   AS ENUM ('PURCHASE', 'USAGE', 'ADJUSTMENT', 'WASTE', 'RETURN');
CREATE TYPE "item_status"                  AS ENUM ('AVAILABLE', 'OUT_OF_STOCK', 'TEMPORARILY_UNAVAILABLE');
CREATE TYPE "notification_channel"         AS ENUM ('EMAIL', 'SMS', 'PUSH', 'WEBHOOK');
CREATE TYPE "notification_event"           AS ENUM (
    'ORDER_PLACED', 'ORDER_READY', 'ORDER_DELIVERED', 'ORDER_CANCELLED',
    'PAYMENT_RECEIVED', 'PAYMENT_FAILED', 'LOW_STOCK', 'EMPLOYEE_PAYMENT_APPROVED'
);
CREATE TYPE "notification_status"          AS ENUM ('PENDING', 'SENT', 'FAILED', 'SKIPPED');
CREATE TYPE "order_status"                 AS ENUM ('PENDING', 'PREPARING', 'READY', 'DELIVERED', 'COMPLETED', 'CANCELLED');
CREATE TYPE "order_type"                   AS ENUM ('DINE_IN', 'TAKEAWAY', 'DELIVERY');
CREATE TYPE "payment_method"               AS ENUM ('CASH', 'CARD', 'MOBILE_BANKING', 'ONLINE', 'VOUCHER');
CREATE TYPE "payment_status"               AS ENUM ('PENDING', 'PAID', 'PARTIAL', 'REFUNDED');
CREATE TYPE "payment_transaction_status"   AS ENUM ('SUCCESS', 'FAILED', 'PENDING', 'REFUNDED');
CREATE TYPE "promotion_type"               AS ENUM ('PERCENTAGE', 'FIXED');
CREATE TYPE "storage_provider"             AS ENUM ('S3', 'LOCAL', 'CLOUDINARY');
CREATE TYPE "table_session_status"         AS ENUM ('OPEN', 'BILLED', 'CLOSED', 'RESERVED');
