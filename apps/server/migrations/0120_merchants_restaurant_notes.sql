CREATE TABLE "merchants"."restaurant_notes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"body" text NOT NULL,
	"author_id" uuid NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	CONSTRAINT "restaurant_notes_body" CHECK (length("merchants"."restaurant_notes"."body") BETWEEN 1 AND 500)
);
--> statement-breakpoint
ALTER TABLE "merchants"."restaurant_notes" ADD CONSTRAINT "restaurant_notes_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "restaurant_notes_key" ON "merchants"."restaurant_notes" USING btree ("author_id","idempotency_key");--> statement-breakpoint
CREATE INDEX "restaurant_notes_restaurant" ON "merchants"."restaurant_notes" USING btree ("restaurant_id","created_at");--> statement-breakpoint
CREATE INDEX "events_target" ON "audit"."events" USING btree ("target_type","target_id","occurred_at");