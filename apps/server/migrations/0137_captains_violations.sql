CREATE TABLE "captains"."violations" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"type_code" text NOT NULL,
	"type_label" text NOT NULL,
	"type_note" text,
	"severe" boolean NOT NULL,
	"suggested_step" text NOT NULL,
	"step" text NOT NULL,
	"order_id" uuid,
	"order_number" bigint,
	"reason" text NOT NULL,
	"suspended_until" timestamp with time zone,
	"recorded_by" uuid NOT NULL,
	"recorded_at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	"appeal_ticket_id" uuid,
	"appealed_at" timestamp with time zone,
	"appeal_outcome" text,
	"appeal_decided_by" uuid,
	"appeal_decided_at" timestamp with time zone,
	CONSTRAINT "violations_step_values" CHECK ("captains"."violations"."step" IN ('warning', 'suspension_1d', 'suspension_7d', 'termination')),
	CONSTRAINT "violations_suggested_step_values" CHECK ("captains"."violations"."suggested_step" IN ('warning', 'suspension_1d', 'suspension_7d', 'termination')),
	CONSTRAINT "violations_appeal_outcome_values" CHECK ("captains"."violations"."appeal_outcome" IN ('accepted', 'rejected')),
	CONSTRAINT "violations_reason" CHECK (length("captains"."violations"."reason") BETWEEN 1 AND 500),
	CONSTRAINT "violations_order" CHECK (("captains"."violations"."order_id" IS NULL) = ("captains"."violations"."order_number" IS NULL)),
	CONSTRAINT "violations_suspension" CHECK (("captains"."violations"."suspended_until" IS NOT NULL) = ("captains"."violations"."step" IN ('suspension_1d', 'suspension_7d'))),
	CONSTRAINT "violations_appeal" CHECK (("captains"."violations"."appeal_ticket_id" IS NULL) = ("captains"."violations"."appealed_at" IS NULL)
          AND ("captains"."violations"."appeal_outcome" IS NULL OR "captains"."violations"."appeal_ticket_id" IS NOT NULL)
          AND (("captains"."violations"."appeal_outcome" IS NULL) = ("captains"."violations"."appeal_decided_by" IS NULL))
          AND (("captains"."violations"."appeal_outcome" IS NULL) = ("captains"."violations"."appeal_decided_at" IS NULL)))
);
--> statement-breakpoint
ALTER TABLE "captains"."violations" ADD CONSTRAINT "violations_captain_id_captains_id_fk" FOREIGN KEY ("captain_id") REFERENCES "captains"."captains"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "violations_key" ON "captains"."violations" USING btree ("recorded_by","idempotency_key");--> statement-breakpoint
CREATE UNIQUE INDEX "violations_appeal_ticket" ON "captains"."violations" USING btree ("appeal_ticket_id");--> statement-breakpoint
CREATE INDEX "violations_captain" ON "captains"."violations" USING btree ("captain_id","recorded_at");--> statement-breakpoint
REVOKE UPDATE ON "captains"."violations" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("appeal_ticket_id", "appealed_at", "appeal_outcome", "appeal_decided_by", "appeal_decided_at") ON "captains"."violations" TO fox_drop_app;--> statement-breakpoint
-- AP §9.7.6 (owner decision 2026-11-19): the violation types, editable in Content; the severe ones terminate at once.
INSERT INTO "content"."reasons" ("list", "code", "label", "customer_text", "note", "fixed", "position") VALUES
	('captain_violation', 'repeated_delay', 'تأخير متكرر', NULL, 'none', false, 1),
	('captain_violation', 'customer_mistreatment', 'سوء معاملة الزبون', NULL, 'none', false, 2),
	('captain_violation', 'overcharging', 'طلب مبلغ أكثر من التطبيق', NULL, 'none', false, 3),
	('captain_violation', 'no_helmet', 'عدم ارتداء الخوذة', NULL, 'none', false, 4),
	('captain_violation', 'packaging_neglect', 'إهمال التغليف', NULL, 'none', false, 5),
	('captain_violation', 'other', 'أخرى', NULL, 'required', false, 6),
	('captain_violation_severe', 'theft', 'سرقة', NULL, 'none', false, 1),
	('captain_violation_severe', 'harassment', 'تحرش', NULL, 'none', false, 2),
	('captain_violation_severe', 'violence', 'عنف', NULL, 'none', false, 3);
