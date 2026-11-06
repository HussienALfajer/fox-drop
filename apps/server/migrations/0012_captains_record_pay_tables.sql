CREATE SCHEMA "captains";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "captains" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "captains" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "captains" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "captains"."captains" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"name" text NOT NULL,
	"vehicle" text NOT NULL,
	"plate_number" text,
	"status" text DEFAULT 'active' NOT NULL,
	"suspension_reason" text,
	"suspended_until" timestamp with time zone,
	"custody_limit" bigint NOT NULL,
	"custody_limit_currency" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "captains_vehicle_values" CHECK ("captains"."captains"."vehicle" IN ('walking', 'bicycle', 'motorbike', 'car')),
	CONSTRAINT "captains_status_values" CHECK ("captains"."captains"."status" IN ('active', 'suspended', 'terminated')),
	CONSTRAINT "captains_plate_number" CHECK ("captains"."captains"."vehicle" NOT IN ('motorbike', 'car') OR "captains"."captains"."plate_number" IS NOT NULL),
	CONSTRAINT "captains_suspension" CHECK (("captains"."captains"."status" = 'suspended') = ("captains"."captains"."suspension_reason" IS NOT NULL)
          AND ("captains"."captains"."suspended_until" IS NULL OR "captains"."captains"."status" = 'suspended')),
	CONSTRAINT "captains_custody_limit" CHECK ("captains"."captains"."custody_limit" > 0)
);
--> statement-breakpoint
CREATE TABLE "captains"."online_periods" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"captain_id" uuid NOT NULL,
	"started_at" timestamp with time zone NOT NULL,
	"app_version" text,
	"ended_at" timestamp with time zone,
	"end_reason" text,
	CONSTRAINT "online_periods_end" CHECK (("captains"."online_periods"."ended_at" IS NULL) = ("captains"."online_periods"."end_reason" IS NULL)
          AND ("captains"."online_periods"."ended_at" IS NULL OR "captains"."online_periods"."ended_at" >= "captains"."online_periods"."started_at")),
	CONSTRAINT "online_periods_end_reason_values" CHECK ("captains"."online_periods"."end_reason" IN ('captain', 'suspended', 'terminated'))
);
--> statement-breakpoint
CREATE TABLE "captains"."pay_rates" (
	"table_id" uuid NOT NULL,
	"vehicle" text NOT NULL,
	"base_pay" bigint NOT NULL,
	"included_metres" integer NOT NULL,
	"per_extra_km" bigint NOT NULL,
	"waiting_per_minute" bigint NOT NULL,
	"minimum_pay" bigint NOT NULL,
	CONSTRAINT "pay_rates_table_id_vehicle_pk" PRIMARY KEY("table_id","vehicle"),
	CONSTRAINT "pay_rates_vehicle_values" CHECK ("captains"."pay_rates"."vehicle" IN ('walking', 'bicycle', 'motorbike', 'car')),
	CONSTRAINT "pay_rates_amounts" CHECK ("captains"."pay_rates"."base_pay" >= 0 AND "captains"."pay_rates"."per_extra_km" >= 0 AND "captains"."pay_rates"."waiting_per_minute" >= 0
          AND "captains"."pay_rates"."minimum_pay" >= 0 AND "captains"."pay_rates"."included_metres" >= 0)
);
--> statement-breakpoint
CREATE TABLE "captains"."pay_tables" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"currency" text NOT NULL,
	"effective_from" timestamp with time zone NOT NULL,
	"editor_type" text NOT NULL,
	"editor_id" uuid,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "pay_tables_editor_type_values" CHECK ("captains"."pay_tables"."editor_type" IN ('admin', 'system')),
	CONSTRAINT "pay_tables_editor" CHECK (("captains"."pay_tables"."editor_type" = 'system') = ("captains"."pay_tables"."editor_id" IS NULL))
);
--> statement-breakpoint
ALTER TABLE "captains"."online_periods" ADD CONSTRAINT "online_periods_captain_id_captains_id_fk" FOREIGN KEY ("captain_id") REFERENCES "captains"."captains"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "captains"."pay_rates" ADD CONSTRAINT "pay_rates_table_id_pay_tables_id_fk" FOREIGN KEY ("table_id") REFERENCES "captains"."pay_tables"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "captains_city" ON "captains"."captains" USING btree ("city_id");--> statement-breakpoint
CREATE UNIQUE INDEX "online_periods_one_open" ON "captains"."online_periods" USING btree ("captain_id") WHERE "captains"."online_periods"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "online_periods_captain" ON "captains"."online_periods" USING btree ("captain_id","started_at" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "pay_tables_current" ON "captains"."pay_tables" USING btree ("city_id","effective_from" DESC NULLS LAST,"id" DESC NULLS LAST);--> statement-breakpoint
REVOKE UPDATE ON "captains"."pay_tables", "captains"."pay_rates" FROM fox_drop_app;
