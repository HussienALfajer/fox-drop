CREATE SCHEMA "support";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "support" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "support" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "support" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "support"."note_keys" (
	"account_id" uuid NOT NULL,
	"key" text NOT NULL,
	"request_hash" text NOT NULL,
	"note_id" uuid NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "note_keys_account_id_key_pk" PRIMARY KEY("account_id","key")
);
--> statement-breakpoint
CREATE TABLE "support"."ticket_notes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"ticket_id" uuid NOT NULL,
	"author_id" uuid NOT NULL,
	"body" text NOT NULL,
	"created_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "support"."ticket_numbers" (
	"city_id" uuid PRIMARY KEY NOT NULL,
	"last_number" bigint NOT NULL
);
--> statement-breakpoint
CREATE TABLE "support"."tickets" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"number" bigint NOT NULL,
	"source" text NOT NULL,
	"party" text NOT NULL,
	"party_id" uuid NOT NULL,
	"order_id" uuid,
	"order_number" bigint,
	"order_active" boolean NOT NULL,
	"type_code" text NOT NULL,
	"type_label" text NOT NULL,
	"description" text NOT NULL,
	"status" text NOT NULL,
	"assignee_id" uuid,
	"sla_kind" text NOT NULL,
	"sla_due_at" timestamp with time zone NOT NULL,
	"sla_stopped_at" timestamp with time zone,
	"opened_by" uuid NOT NULL,
	"opened_at" timestamp with time zone NOT NULL,
	"updated_at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	CONSTRAINT "tickets_source_values" CHECK ("support"."tickets"."source" IN ('manual')),
	CONSTRAINT "tickets_party_values" CHECK ("support"."tickets"."party" IN ('customer', 'restaurant', 'captain')),
	CONSTRAINT "tickets_status_values" CHECK ("support"."tickets"."status" IN ('new', 'in_progress', 'waiting', 'resolved', 'closed')),
	CONSTRAINT "tickets_sla_kind_values" CHECK ("support"."tickets"."sla_kind" IN ('first_response', 'resolution')),
	CONSTRAINT "tickets_order" CHECK (("support"."tickets"."order_id" IS NULL) = ("support"."tickets"."order_number" IS NULL) AND ("support"."tickets"."order_id" IS NOT NULL OR NOT "support"."tickets"."order_active"))
);
--> statement-breakpoint
ALTER TABLE "notifications"."alerts" DROP CONSTRAINT "alerts_subject_type";--> statement-breakpoint
ALTER TABLE "support"."ticket_notes" ADD CONSTRAINT "ticket_notes_ticket_id_tickets_id_fk" FOREIGN KEY ("ticket_id") REFERENCES "support"."tickets"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "ticket_notes_ticket" ON "support"."ticket_notes" USING btree ("ticket_id","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "tickets_city_number" ON "support"."tickets" USING btree ("city_id","number");--> statement-breakpoint
CREATE UNIQUE INDEX "tickets_opened_by_key" ON "support"."tickets" USING btree ("opened_by","idempotency_key");--> statement-breakpoint
CREATE INDEX "tickets_city_opened" ON "support"."tickets" USING btree ("city_id","opened_at");--> statement-breakpoint
CREATE INDEX "tickets_order" ON "support"."tickets" USING btree ("order_id");--> statement-breakpoint
ALTER TABLE "notifications"."alerts" ADD CONSTRAINT "alerts_subject_type" CHECK ("notifications"."alerts"."subject_type" IN ('order', 'captain', 'otp_pool', 'otp_number', 'restaurant', 'currency', 'compensation', 'ticket')) NOT VALID;--> statement-breakpoint
ALTER TABLE "notifications"."alerts" VALIDATE CONSTRAINT "alerts_subject_type";--> statement-breakpoint
-- AP §4.5: an internal note is never changed.
REVOKE UPDATE ON "support"."ticket_notes", "support"."note_keys" FROM fox_drop_app;--> statement-breakpoint
-- A ticket's number, party, order and opening never change; only its state does.
REVOKE UPDATE ON "support"."tickets" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("status", "assignee_id", "sla_stopped_at", "order_active", "updated_at") ON "support"."tickets" TO fox_drop_app;