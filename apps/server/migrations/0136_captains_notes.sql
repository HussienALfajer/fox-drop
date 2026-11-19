CREATE TABLE "captains"."notes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"body" text NOT NULL,
	"author_id" uuid NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	CONSTRAINT "notes_body" CHECK (length("captains"."notes"."body") BETWEEN 1 AND 500)
);
--> statement-breakpoint
ALTER TABLE "captains"."notes" ADD CONSTRAINT "notes_captain_id_captains_id_fk" FOREIGN KEY ("captain_id") REFERENCES "captains"."captains"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "notes_key" ON "captains"."notes" USING btree ("author_id","idempotency_key");--> statement-breakpoint
CREATE INDEX "notes_captain" ON "captains"."notes" USING btree ("captain_id","created_at");--> statement-breakpoint
REVOKE UPDATE ON "captains"."notes" FROM fox_drop_app;