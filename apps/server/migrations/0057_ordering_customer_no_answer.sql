CREATE TABLE "ordering"."door_pings" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"captain_id" uuid NOT NULL,
	"sent_at" timestamp with time zone NOT NULL,
	"answer" text,
	"answered_at" timestamp with time zone,
	CONSTRAINT "door_pings_answer" CHECK (("ordering"."door_pings"."answer" IS NULL) = ("ordering"."door_pings"."answered_at" IS NULL)
        AND ("ordering"."door_pings"."answer" IS NULL OR "ordering"."door_pings"."answer" IN ('coming', 'contacting_recipient')))
);
--> statement-breakpoint
CREATE TABLE "ordering"."no_answer_reports" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"reported_at" timestamp with time zone NOT NULL,
	"waited_at" timestamp with time zone,
	"wait_message" text,
	"waited_by" uuid,
	"closed_at" timestamp with time zone,
	"closed_how" text,
	CONSTRAINT "no_answer_reports_wait" CHECK (("ordering"."no_answer_reports"."waited_at" IS NULL) = ("ordering"."no_answer_reports"."wait_message" IS NULL)
        AND ("ordering"."no_answer_reports"."waited_at" IS NULL) = ("ordering"."no_answer_reports"."waited_by" IS NULL)
        AND ("ordering"."no_answer_reports"."wait_message" IS NULL OR length("ordering"."no_answer_reports"."wait_message") BETWEEN 1 AND 300)),
	CONSTRAINT "no_answer_reports_closed" CHECK (("ordering"."no_answer_reports"."closed_at" IS NULL) = ("ordering"."no_answer_reports"."closed_how" IS NULL)
        AND ("ordering"."no_answer_reports"."closed_how" IS NULL OR "ordering"."no_answer_reports"."closed_how" IN ('handed_over', 'ended'))
        AND ("ordering"."no_answer_reports"."closed_at" IS NULL OR "ordering"."no_answer_reports"."waited_at" IS NULL))
);
--> statement-breakpoint
ALTER TABLE "ordering"."door_pings" ADD CONSTRAINT "door_pings_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ordering"."no_answer_reports" ADD CONSTRAINT "no_answer_reports_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "door_pings_order" ON "ordering"."door_pings" USING btree ("order_id","order_placed_at","sent_at");--> statement-breakpoint
CREATE UNIQUE INDEX "no_answer_reports_one_open_per_order" ON "ordering"."no_answer_reports" USING btree ("order_id") WHERE "ordering"."no_answer_reports"."waited_at" IS NULL AND "ordering"."no_answer_reports"."closed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "no_answer_reports_order" ON "ordering"."no_answer_reports" USING btree ("order_id","order_placed_at","reported_at");--> statement-breakpoint
REVOKE UPDATE ON "ordering"."door_pings" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("answer", "answered_at") ON "ordering"."door_pings" TO fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "ordering"."no_answer_reports" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("waited_at", "wait_message", "waited_by", "closed_at", "closed_how") ON "ordering"."no_answer_reports" TO fox_drop_app;