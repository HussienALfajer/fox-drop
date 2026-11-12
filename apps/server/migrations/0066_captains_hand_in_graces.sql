CREATE TABLE "captains"."hand_in_graces" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"captain_id" uuid,
	"until" timestamp with time zone NOT NULL,
	"reason" text NOT NULL,
	"granted_by" uuid NOT NULL,
	"granted_at" timestamp with time zone NOT NULL,
	CONSTRAINT "hand_in_graces_reason" CHECK (length(btrim("captains"."hand_in_graces"."reason")) > 0),
	CONSTRAINT "hand_in_graces_until" CHECK ("captains"."hand_in_graces"."until" > "captains"."hand_in_graces"."granted_at")
);
--> statement-breakpoint
ALTER TABLE "captains"."hand_in_graces" ADD CONSTRAINT "hand_in_graces_captain_id_captains_id_fk" FOREIGN KEY ("captain_id") REFERENCES "captains"."captains"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "hand_in_graces_city_until" ON "captains"."hand_in_graces" USING btree ("city_id","until");--> statement-breakpoint
CREATE INDEX "hand_in_graces_captain_until" ON "captains"."hand_in_graces" USING btree ("captain_id","until");--> statement-breakpoint
-- AP §8.5.4: a grace stays as granted.
REVOKE UPDATE ON "captains"."hand_in_graces" FROM fox_drop_app;
