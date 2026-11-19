-- Slice 2.37a: a restaurant's own delivery fee rule (AP §9.12.3). Expand
-- only: a nullable column, a partial index, and the kind and currency checks
-- widened for `city_rule`, added NOT VALID then validated (short locks).
ALTER TABLE "geo"."fee_rules" ADD COLUMN "restaurant_id" uuid;--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" ALTER COLUMN "currency" DROP NOT NULL;--> statement-breakpoint
CREATE INDEX "fee_rules_restaurant_current" ON "geo"."fee_rules" USING btree ("restaurant_id","id" DESC NULLS LAST) WHERE "geo"."fee_rules"."restaurant_id" IS NOT NULL;--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" DROP CONSTRAINT "fee_rules_kind_values";--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" ADD CONSTRAINT "fee_rules_kind_values" CHECK ("geo"."fee_rules"."kind" IN ('flat', 'distance_bands', 'city_rule')) NOT VALID;--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" ADD CONSTRAINT "fee_rules_city_rule" CHECK ("geo"."fee_rules"."kind" <> 'city_rule' OR "geo"."fee_rules"."restaurant_id" IS NOT NULL) NOT VALID;--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" ADD CONSTRAINT "fee_rules_currency" CHECK (("geo"."fee_rules"."kind" = 'city_rule') = ("geo"."fee_rules"."currency" IS NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" VALIDATE CONSTRAINT "fee_rules_kind_values";--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" VALIDATE CONSTRAINT "fee_rules_city_rule";--> statement-breakpoint
ALTER TABLE "geo"."fee_rules" VALIDATE CONSTRAINT "fee_rules_currency";
