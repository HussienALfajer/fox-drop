CREATE TABLE "geo"."fee_bands" (
	"rule_id" uuid NOT NULL,
	"position" smallint NOT NULL,
	"up_to_metres" integer,
	"fee" bigint NOT NULL,
	CONSTRAINT "fee_bands_rule_id_position_pk" PRIMARY KEY("rule_id","position"),
	CONSTRAINT "fee_bands_up_to_positive" CHECK ("geo"."fee_bands"."up_to_metres" > 0),
	CONSTRAINT "fee_bands_fee" CHECK ("geo"."fee_bands"."fee" >= 0)
);
--> statement-breakpoint
CREATE TABLE "geo"."fee_rules" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"currency" text NOT NULL,
	"flat_fee" bigint,
	"minimum_fee" bigint,
	"free_delivery_from" bigint,
	"editor_id" uuid,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "fee_rules_kind_values" CHECK ("geo"."fee_rules"."kind" IN ('flat', 'distance_bands')),
	CONSTRAINT "fee_rules_flat_fee" CHECK (("geo"."fee_rules"."kind" = 'flat') = ("geo"."fee_rules"."flat_fee" IS NOT NULL) AND "geo"."fee_rules"."flat_fee" >= 0),
	CONSTRAINT "fee_rules_minimum_fee" CHECK ("geo"."fee_rules"."minimum_fee" >= 0),
	CONSTRAINT "fee_rules_free_delivery_from" CHECK ("geo"."fee_rules"."free_delivery_from" > 0)
);
--> statement-breakpoint
CREATE TABLE "geo"."zones" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"name" text NOT NULL,
	"area" geometry(Polygon,4326) NOT NULL,
	"active" boolean NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "zones_city_name" UNIQUE("city_id","name"),
	CONSTRAINT "zones_area_valid" CHECK (ST_IsValid("geo"."zones"."area"))
);
--> statement-breakpoint
ALTER TABLE "geo"."fee_bands" ADD CONSTRAINT "fee_bands_rule_id_fee_rules_id_fk" FOREIGN KEY ("rule_id") REFERENCES "geo"."fee_rules"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" ADD CONSTRAINT "fee_rules_city_id_cities_id_fk" FOREIGN KEY ("city_id") REFERENCES "geo"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "geo"."zones" ADD CONSTRAINT "zones_city_id_cities_id_fk" FOREIGN KEY ("city_id") REFERENCES "geo"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "fee_rules_current" ON "geo"."fee_rules" USING btree ("city_id","id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "zones_area" ON "geo"."zones" USING gist ("area");--> statement-breakpoint
-- A fee rule change is a new version, never an update (AP §9.12.3): the
-- application role adds and reads fee rules and their bands only.
REVOKE UPDATE ON "geo"."fee_rules" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "geo"."fee_bands" FROM fox_drop_app;
