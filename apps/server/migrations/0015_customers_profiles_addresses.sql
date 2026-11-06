CREATE SCHEMA "customers";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "customers" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "customers" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "customers" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "customers"."addresses" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"location" geometry(Point,4326) NOT NULL,
	"label" text NOT NULL,
	"custom_label" text,
	"street" text NOT NULL,
	"floor" text,
	"landmark" text NOT NULL,
	"contact_phone_encrypted" text,
	"recipient_name" text,
	"directions" text,
	"is_default" boolean DEFAULT false NOT NULL,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "addresses_label_values" CHECK ("customers"."addresses"."label" IN ('home', 'work', 'other')),
	CONSTRAINT "addresses_custom_label" CHECK (("customers"."addresses"."label" = 'other') = ("customers"."addresses"."custom_label" IS NOT NULL)),
	CONSTRAINT "addresses_recipient" CHECK (("customers"."addresses"."contact_phone_encrypted" IS NULL) = ("customers"."addresses"."recipient_name" IS NULL))
);
--> statement-breakpoint
CREATE TABLE "customers"."profiles" (
	"account_id" uuid PRIMARY KEY NOT NULL,
	"first_name" text NOT NULL,
	"last_name" text,
	"gender" text NOT NULL,
	"birthday" date,
	"terms_accepted_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "profiles_gender_values" CHECK ("customers"."profiles"."gender" IN ('male', 'female'))
);
--> statement-breakpoint
CREATE TABLE "geo"."zone_votes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid,
	"device_id" uuid NOT NULL,
	"location" geometry(Point,4326) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "geo"."zone_votes" ADD CONSTRAINT "zone_votes_city_id_cities_id_fk" FOREIGN KEY ("city_id") REFERENCES "geo"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "addresses_account" ON "customers"."addresses" USING btree ("account_id");--> statement-breakpoint
CREATE UNIQUE INDEX "addresses_one_default" ON "customers"."addresses" USING btree ("account_id") WHERE "customers"."addresses"."is_default" AND "customers"."addresses"."deleted_at" IS NULL;--> statement-breakpoint
CREATE INDEX "zone_votes_city" ON "geo"."zone_votes" USING btree ("city_id","created_at");--> statement-breakpoint
CREATE INDEX "zone_votes_device" ON "geo"."zone_votes" USING btree ("device_id");--> statement-breakpoint
CREATE INDEX "zone_votes_location" ON "geo"."zone_votes" USING gist ("location");