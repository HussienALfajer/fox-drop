CREATE SCHEMA "fx";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "fx" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "fx" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "fx"."city_bases" (
	"city_id" uuid PRIMARY KEY NOT NULL,
	"currency" text NOT NULL,
	"epoch" integer DEFAULT 1 NOT NULL,
	"locked_at" timestamp with time zone,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "fx"."city_currencies" (
	"city_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"display_order" integer NOT NULL,
	"enabled" boolean NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "city_currencies_city_id_currency_pk" PRIMARY KEY("city_id","currency")
);
--> statement-breakpoint
CREATE TABLE "fx"."currencies" (
	"code" text PRIMARY KEY NOT NULL,
	"name_ar" text NOT NULL,
	"symbol" text NOT NULL,
	"decimals" smallint NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "currencies_code_format" CHECK ("fx"."currencies"."code" ~ '^[A-Z]{3}$'),
	CONSTRAINT "currencies_decimals_range" CHECK ("fx"."currencies"."decimals" BETWEEN 0 AND 4),
	CONSTRAINT "currencies_status_values" CHECK ("fx"."currencies"."status" IN ('active', 'inactive'))
);
--> statement-breakpoint
CREATE TABLE "fx"."rate_versions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"base_currency" text NOT NULL,
	"base_epoch" integer NOT NULL,
	"rate_numerator" bigint NOT NULL,
	"rate_denominator" bigint NOT NULL,
	"editor_id" uuid NOT NULL,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "rate_versions_rate_positive" CHECK ("fx"."rate_versions"."rate_numerator" > 0 AND "fx"."rate_versions"."rate_denominator" > 0),
	CONSTRAINT "rate_versions_not_base" CHECK ("fx"."rate_versions"."currency" <> "fx"."rate_versions"."base_currency")
);
--> statement-breakpoint
-- The placeholder values of development and staging are set by the system,
-- which has no admin account and no roles (expand only: older rows keep theirs).
ALTER TABLE "settings"."changes" ALTER COLUMN "editor_id" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "fx"."city_bases" ADD CONSTRAINT "city_bases_city_currency" FOREIGN KEY ("city_id","currency") REFERENCES "fx"."city_currencies"("city_id","currency") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "fx"."city_currencies" ADD CONSTRAINT "city_currencies_currency_currencies_code_fk" FOREIGN KEY ("currency") REFERENCES "fx"."currencies"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "fx"."rate_versions" ADD CONSTRAINT "rate_versions_base_currency_currencies_code_fk" FOREIGN KEY ("base_currency") REFERENCES "fx"."currencies"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "fx"."rate_versions" ADD CONSTRAINT "rate_versions_city_currency" FOREIGN KEY ("city_id","currency") REFERENCES "fx"."city_currencies"("city_id","currency") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "city_currencies_by_currency" ON "fx"."city_currencies" USING btree ("currency");--> statement-breakpoint
CREATE INDEX "rate_versions_current" ON "fx"."rate_versions" USING btree ("city_id","base_epoch","currency","id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "rate_versions_by_base_currency" ON "fx"."rate_versions" USING btree ("base_currency");--> statement-breakpoint
ALTER TABLE "settings"."changes" ADD CONSTRAINT "changes_system_has_no_roles" CHECK ("settings"."changes"."editor_id" IS NOT NULL OR cardinality("settings"."changes"."editor_roles") = 0);--> statement-breakpoint
-- A rate change is a new version, never an update (AP §8.6): the application
-- role adds and reads rate versions only.
REVOKE UPDATE ON "fx"."rate_versions" FROM fox_drop_app;--> statement-breakpoint
-- A currency's decimals never change once amounts use it; only its status does.
REVOKE UPDATE ON "fx"."currencies" FROM fox_drop_app;--> statement-breakpoint
GRANT UPDATE ("status") ON "fx"."currencies" TO fox_drop_app;--> statement-breakpoint
-- The city's first order locks its base currency (AP §8.6, D25): from then on
-- neither the currency nor the lock changes, whatever the caller.
CREATE FUNCTION "fx"."city_bases_keep_lock"() RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, pg_temp
AS $$
BEGIN
	IF OLD.locked_at IS NOT NULL AND (
		NEW.currency IS DISTINCT FROM OLD.currency
		OR NEW.epoch IS DISTINCT FROM OLD.epoch
		OR NEW.locked_at IS DISTINCT FROM OLD.locked_at
	) THEN
		RAISE EXCEPTION 'the base currency of city % is locked since its first order', OLD.city_id
			USING ERRCODE = 'check_violation';
	END IF;
	RETURN NEW;
END;
$$;--> statement-breakpoint
CREATE TRIGGER "city_bases_keep_lock" BEFORE UPDATE ON "fx"."city_bases"
	FOR EACH ROW EXECUTE FUNCTION "fx"."city_bases_keep_lock"();--> statement-breakpoint
-- The currencies of V1 (AP §8.6, D25), in every environment. Decimals follow
-- ISO 4217 (owner decision 2026-11-05).
INSERT INTO "fx"."currencies" ("code", "name_ar", "symbol", "decimals") VALUES
	('TRY', 'ليرة تركية', '₺', 2),
	('USD', 'دولار أمريكي', '$', 2),
	('SYP', 'ليرة سورية', 'ل.س', 2);
