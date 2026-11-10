-- Slice 2.11c: «تغيير النتيجة» replaces an outcome with a new row and keeps the old (AP §8.9): the journals each outcome posted, which a change reverses, and one row in force per order.
ALTER TABLE "ordering"."order_outcomes" ADD COLUMN "journal_ids" uuid[];--> statement-breakpoint
ALTER TABLE "ordering"."order_outcomes" ADD COLUMN "replaces_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."order_outcomes" ADD COLUMN "replaced_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "ordering"."order_outcomes" ADD CONSTRAINT "order_outcomes_replaces_id_order_outcomes_id_fk" FOREIGN KEY ("replaces_id") REFERENCES "ordering"."order_outcomes"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "order_outcomes_current" ON "ordering"."order_outcomes" USING btree ("order_id") WHERE "ordering"."order_outcomes"."replaced_at" IS NULL;--> statement-breakpoint
CREATE UNIQUE INDEX "order_outcomes_replaces" ON "ordering"."order_outcomes" USING btree ("replaces_id");--> statement-breakpoint
ALTER TABLE "ordering"."order_outcomes" ADD CONSTRAINT "order_outcomes_change" CHECK (("ordering"."order_outcomes"."replaced_at" IS NULL OR "ordering"."order_outcomes"."journal_ids" IS NOT NULL) AND ("ordering"."order_outcomes"."replaces_id" IS NULL OR "ordering"."order_outcomes"."journal_ids" IS NOT NULL));--> statement-breakpoint
DROP INDEX "ordering"."order_outcomes_order";--> statement-breakpoint
GRANT UPDATE ("journal_ids", "replaced_at") ON "ordering"."order_outcomes" TO fox_drop_app;
