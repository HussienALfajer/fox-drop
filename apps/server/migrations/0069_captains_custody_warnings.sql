CREATE TABLE "captains"."custody_warnings" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid NOT NULL,
	"warned_at" timestamp with time zone NOT NULL,
	"cleared_at" timestamp with time zone,
	CONSTRAINT "custody_warnings_cleared" CHECK ("captains"."custody_warnings"."cleared_at" IS NULL OR "captains"."custody_warnings"."cleared_at" >= "captains"."custody_warnings"."warned_at")
);
--> statement-breakpoint
ALTER TABLE "captains"."custody_warnings" ADD CONSTRAINT "custody_warnings_captain_id_captains_id_fk" FOREIGN KEY ("captain_id") REFERENCES "captains"."captains"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "custody_warnings_captain" ON "captains"."custody_warnings" USING btree ("captain_id","warned_at");--> statement-breakpoint
CREATE UNIQUE INDEX "custody_warnings_one_open" ON "captains"."custody_warnings" USING btree ("captain_id") WHERE "captains"."custody_warnings"."cleared_at" IS NULL;--> statement-breakpoint
-- CA §10.4: a warning is only ever cleared.
REVOKE UPDATE ON "captains"."custody_warnings" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("cleared_at") ON "captains"."custody_warnings" TO fox_drop_app;
