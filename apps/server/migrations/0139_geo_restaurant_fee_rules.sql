-- Slice 2.37a: a restaurant's own delivery fee rule (AP §9.12.3), in tables of
-- its own; versions the application role may only insert, as fee_rules.
CREATE TABLE "geo"."restaurant_fee_bands" (
	"rule_id" uuid NOT NULL,
	"position" smallint NOT NULL,
	"up_to_metres" integer,
	"fee" bigint NOT NULL,
	CONSTRAINT "restaurant_fee_bands_rule_id_position_pk" PRIMARY KEY("rule_id","position"),
	CONSTRAINT "restaurant_fee_bands_up_to_positive" CHECK ("geo"."restaurant_fee_bands"."up_to_metres" > 0),
	CONSTRAINT "restaurant_fee_bands_fee" CHECK ("geo"."restaurant_fee_bands"."fee" >= 0)
);
--> statement-breakpoint
CREATE TABLE "geo"."restaurant_fee_rules" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"currency" text,
	"flat_fee" bigint,
	"minimum_fee" bigint,
	"free_delivery_from" bigint,
	"editor_id" uuid,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "restaurant_fee_rules_kind_values" CHECK ("geo"."restaurant_fee_rules"."kind" IN ('flat', 'distance_bands', 'city_rule')),
	CONSTRAINT "restaurant_fee_rules_currency" CHECK (("geo"."restaurant_fee_rules"."kind" = 'city_rule') = ("geo"."restaurant_fee_rules"."currency" IS NULL)),
	CONSTRAINT "restaurant_fee_rules_flat_fee" CHECK (("geo"."restaurant_fee_rules"."kind" = 'flat') = ("geo"."restaurant_fee_rules"."flat_fee" IS NOT NULL) AND "geo"."restaurant_fee_rules"."flat_fee" >= 0),
	CONSTRAINT "restaurant_fee_rules_minimum_fee" CHECK ("geo"."restaurant_fee_rules"."minimum_fee" >= 0),
	CONSTRAINT "restaurant_fee_rules_free_delivery_from" CHECK ("geo"."restaurant_fee_rules"."free_delivery_from" > 0)
);
--> statement-breakpoint
ALTER TABLE "geo"."restaurant_fee_bands" ADD CONSTRAINT "restaurant_fee_bands_rule_id_restaurant_fee_rules_id_fk" FOREIGN KEY ("rule_id") REFERENCES "geo"."restaurant_fee_rules"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "geo"."restaurant_fee_rules" ADD CONSTRAINT "restaurant_fee_rules_city_id_cities_id_fk" FOREIGN KEY ("city_id") REFERENCES "geo"."cities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "restaurant_fee_rules_current" ON "geo"."restaurant_fee_rules" USING btree ("restaurant_id","id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "restaurant_fee_rules_city" ON "geo"."restaurant_fee_rules" USING btree ("city_id","restaurant_id");--> statement-breakpoint
REVOKE UPDATE ON "geo"."restaurant_fee_rules" FROM fox_drop_app;--> statement-breakpoint
REVOKE UPDATE ON "geo"."restaurant_fee_bands" FROM fox_drop_app;
