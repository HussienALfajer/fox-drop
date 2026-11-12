CREATE TABLE "geo"."office_periods" (
	"office_id" uuid NOT NULL,
	"weekday" smallint NOT NULL,
	"opens_at" smallint NOT NULL,
	"closes_at" smallint NOT NULL,
	CONSTRAINT "office_periods_office_id_weekday_pk" PRIMARY KEY("office_id","weekday"),
	CONSTRAINT "office_periods_weekday" CHECK ("geo"."office_periods"."weekday" BETWEEN 0 AND 6),
	CONSTRAINT "office_periods_opens_at" CHECK ("geo"."office_periods"."opens_at" BETWEEN 0 AND 1439),
	CONSTRAINT "office_periods_closes_at" CHECK ("geo"."office_periods"."closes_at" BETWEEN 0 AND 1440)
);
--> statement-breakpoint
CREATE TABLE "geo"."offices" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"latitude" double precision NOT NULL,
	"longitude" double precision NOT NULL,
	"editor_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "offices_latitude" CHECK ("geo"."offices"."latitude" BETWEEN -90 AND 90),
	CONSTRAINT "offices_longitude" CHECK ("geo"."offices"."longitude" BETWEEN -180 AND 180)
);
--> statement-breakpoint
ALTER TABLE "geo"."office_periods" ADD CONSTRAINT "office_periods_office_id_offices_id_fk" FOREIGN KEY ("office_id") REFERENCES "geo"."offices"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "geo"."offices" ADD CONSTRAINT "offices_city_id_cities_id_fk" FOREIGN KEY ("city_id") REFERENCES "geo"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "offices_current" ON "geo"."offices" USING btree ("city_id","id" DESC NULLS LAST);--> statement-breakpoint
-- AP §9.12.1: an office version stays as saved; a change adds one.
REVOKE UPDATE ON "geo"."offices" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "geo"."office_periods" FROM fox_drop_app;
