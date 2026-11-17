CREATE TABLE "customers"."device_lifts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"device_id" text NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"by" uuid NOT NULL,
	"note" text NOT NULL,
	CONSTRAINT "device_lifts_note" CHECK (length("customers"."device_lifts"."note") BETWEEN 1 AND 500)
);
--> statement-breakpoint
CREATE INDEX "device_lifts_device_at" ON "customers"."device_lifts" USING btree ("device_id","at");--> statement-breakpoint
CREATE INDEX "app_sessions_customer_account" ON "identity"."app_sessions" USING btree ("account_id") WHERE "identity"."app_sessions"."party" = 'customer';--> statement-breakpoint
CREATE INDEX "app_sessions_customer_device" ON "identity"."app_sessions" USING btree ("device_id") WHERE "identity"."app_sessions"."party" = 'customer';--> statement-breakpoint
REVOKE UPDATE ON "customers"."device_lifts" FROM fox_drop_app;--> statement-breakpoint
-- AP §9.8, §6.3 (slice 2.25d, owner decision 2026-11-18): «فك حظر الجهاز», OWN alone.
INSERT INTO "identity"."admin_permissions" ("code") VALUES ('customers.lift_device_block');--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OWN', 'customers.lift_device_block');
