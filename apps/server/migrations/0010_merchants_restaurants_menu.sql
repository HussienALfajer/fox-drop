CREATE SCHEMA "merchants";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "merchants" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "merchants" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "merchants" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "merchants"."categories" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"name" text NOT NULL,
	"position" integer NOT NULL,
	"hidden" boolean DEFAULT false NOT NULL,
	"available" boolean DEFAULT true NOT NULL,
	"unavailable_until" timestamp with time zone,
	"window_starts_at" smallint,
	"window_ends_at" smallint,
	"published" boolean NOT NULL,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "categories_window" CHECK (("merchants"."categories"."window_starts_at" IS NULL) = ("merchants"."categories"."window_ends_at" IS NULL) AND "merchants"."categories"."window_starts_at" BETWEEN 0 AND 1439 AND "merchants"."categories"."window_ends_at" BETWEEN 0 AND 1440)
);
--> statement-breakpoint
CREATE TABLE "merchants"."change_requests" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"target_type" text NOT NULL,
	"target_id" uuid NOT NULL,
	"field" text NOT NULL,
	"pending_value" jsonb NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"requested_by_id" uuid NOT NULL,
	"reviewed_by_id" uuid,
	"reviewed_at" timestamp with time zone,
	"approved_value" jsonb,
	"rejection_reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "change_requests_target_type_values" CHECK ("merchants"."change_requests"."target_type" IN ('category', 'item', 'option_group', 'option')),
	CONSTRAINT "change_requests_status_values" CHECK ("merchants"."change_requests"."status" IN ('pending', 'approved', 'rejected', 'withdrawn')),
	CONSTRAINT "change_requests_rejection_reason" CHECK (("merchants"."change_requests"."status" = 'rejected') = ("merchants"."change_requests"."rejection_reason" IS NOT NULL))
);
--> statement-breakpoint
CREATE TABLE "merchants"."commission_rates" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"rate_bp" integer NOT NULL,
	"effective_from" timestamp with time zone NOT NULL,
	"changed_by_type" text NOT NULL,
	"changed_by_id" uuid,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "commission_rates_rate" CHECK ("merchants"."commission_rates"."rate_bp" BETWEEN 0 AND 10000),
	CONSTRAINT "commission_rates_changed_by_type_values" CHECK ("merchants"."commission_rates"."changed_by_type" IN ('admin', 'merchant', 'system'))
);
--> statement-breakpoint
CREATE TABLE "merchants"."coverage_zones" (
	"restaurant_id" uuid NOT NULL,
	"zone_id" uuid NOT NULL,
	"removed_at" timestamp with time zone,
	CONSTRAINT "coverage_zones_restaurant_id_zone_id_pk" PRIMARY KEY("restaurant_id","zone_id")
);
--> statement-breakpoint
CREATE TABLE "merchants"."holiday_closes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"ends_at" timestamp with time zone NOT NULL,
	"message" text,
	"reason" text,
	"set_by_type" text NOT NULL,
	"set_by_id" uuid,
	"ended_at" timestamp with time zone,
	"ended_by_type" text,
	"ended_by_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "holiday_closes_period" CHECK ("merchants"."holiday_closes"."ends_at" > "merchants"."holiday_closes"."starts_at"),
	CONSTRAINT "holiday_closes_message" CHECK (char_length("merchants"."holiday_closes"."message") <= 100),
	CONSTRAINT "holiday_closes_set_by_type_values" CHECK ("merchants"."holiday_closes"."set_by_type" IN ('admin', 'merchant', 'system')),
	CONSTRAINT "holiday_closes_ended_by_type_values" CHECK ("merchants"."holiday_closes"."ended_by_type" IN ('admin', 'merchant', 'system'))
);
--> statement-breakpoint
CREATE TABLE "merchants"."item_option_groups" (
	"item_id" uuid NOT NULL,
	"group_id" uuid NOT NULL,
	"position" integer NOT NULL,
	"removed_at" timestamp with time zone,
	CONSTRAINT "item_option_groups_item_id_group_id_pk" PRIMARY KEY("item_id","group_id")
);
--> statement-breakpoint
CREATE TABLE "merchants"."items" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"category_id" uuid NOT NULL,
	"code" text NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"price" bigint NOT NULL,
	"currency" text NOT NULL,
	"photo_key" text,
	"position" integer NOT NULL,
	"available" boolean DEFAULT true NOT NULL,
	"unavailable_until" timestamp with time zone,
	"hidden" boolean DEFAULT false NOT NULL,
	"badge" text,
	"published" boolean NOT NULL,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "items_restaurant_code" UNIQUE("restaurant_id","code"),
	CONSTRAINT "items_price" CHECK ("merchants"."items"."price" > 0),
	CONSTRAINT "items_badge_values" CHECK ("merchants"."items"."badge" IN ('new', 'most_ordered', 'spicy'))
);
--> statement-breakpoint
CREATE TABLE "merchants"."opening_periods" (
	"schedule_id" uuid NOT NULL,
	"weekday" smallint NOT NULL,
	"opens_at" smallint NOT NULL,
	"closes_at" smallint NOT NULL,
	CONSTRAINT "opening_periods_schedule_id_weekday_opens_at_pk" PRIMARY KEY("schedule_id","weekday","opens_at"),
	CONSTRAINT "opening_periods_weekday" CHECK ("merchants"."opening_periods"."weekday" BETWEEN 0 AND 6),
	CONSTRAINT "opening_periods_opens_at" CHECK ("merchants"."opening_periods"."opens_at" BETWEEN 0 AND 1439),
	CONSTRAINT "opening_periods_closes_at" CHECK ("merchants"."opening_periods"."closes_at" BETWEEN 0 AND 1440)
);
--> statement-breakpoint
CREATE TABLE "merchants"."option_groups" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"name" text NOT NULL,
	"min_choices" smallint NOT NULL,
	"max_choices" smallint NOT NULL,
	"published" boolean NOT NULL,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "option_groups_choices" CHECK ("merchants"."option_groups"."min_choices" >= 0 AND "merchants"."option_groups"."max_choices" >= 1 AND "merchants"."option_groups"."max_choices" >= "merchants"."option_groups"."min_choices")
);
--> statement-breakpoint
CREATE TABLE "merchants"."options" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"group_id" uuid NOT NULL,
	"name" text NOT NULL,
	"price_delta" bigint NOT NULL,
	"currency" text NOT NULL,
	"position" integer NOT NULL,
	"available" boolean DEFAULT true NOT NULL,
	"unavailable_until" timestamp with time zone,
	"published" boolean NOT NULL,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "options_price_delta" CHECK ("merchants"."options"."price_delta" >= 0)
);
--> statement-breakpoint
CREATE TABLE "merchants"."pauses" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"source" text NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"ends_at" timestamp with time zone,
	"message" text,
	"reason" text,
	"set_by_id" uuid,
	"ended_at" timestamp with time zone,
	"ended_by_type" text,
	"ended_by_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "pauses_source_values" CHECK ("merchants"."pauses"."source" IN ('restaurant', 'ops', 'auto')),
	CONSTRAINT "pauses_period" CHECK ("merchants"."pauses"."ends_at" > "merchants"."pauses"."starts_at"),
	CONSTRAINT "pauses_restaurant_ends" CHECK ("merchants"."pauses"."source" <> 'restaurant' OR "merchants"."pauses"."ends_at" IS NOT NULL),
	CONSTRAINT "pauses_ended_by_type_values" CHECK ("merchants"."pauses"."ended_by_type" IN ('admin', 'merchant', 'system'))
);
--> statement-breakpoint
CREATE TABLE "merchants"."price_changes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"item_id" uuid,
	"option_id" uuid,
	"currency" text NOT NULL,
	"old_price" bigint NOT NULL,
	"new_price" bigint NOT NULL,
	"changed_by_type" text NOT NULL,
	"changed_by_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "price_changes_target" CHECK (num_nonnulls("merchants"."price_changes"."item_id", "merchants"."price_changes"."option_id") = 1),
	CONSTRAINT "price_changes_changed_by_type_values" CHECK ("merchants"."price_changes"."changed_by_type" IN ('admin', 'merchant', 'system'))
);
--> statement-breakpoint
CREATE TABLE "merchants"."restaurants" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"name_ar" text NOT NULL,
	"name_en" text,
	"category" text,
	"description" text,
	"logo_key" text,
	"cover_key" text,
	"location" geometry(Point,4326) NOT NULL,
	"address" text,
	"phone" text,
	"account_status" text DEFAULT 'draft' NOT NULL,
	"suspension_reason" text,
	"visible" boolean DEFAULT true NOT NULL,
	"sort_weight" integer DEFAULT 0 NOT NULL,
	"coverage_kind" text NOT NULL,
	"coverage_radius_metres" integer,
	"minimum_order" bigint NOT NULL,
	"minimum_order_currency" text NOT NULL,
	"default_prep_min" smallint NOT NULL,
	"max_active_orders" smallint,
	"busy_extra_min" smallint,
	"busy_until" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "restaurants_account_status_values" CHECK ("merchants"."restaurants"."account_status" IN ('draft', 'test', 'active', 'suspended', 'terminated')),
	CONSTRAINT "restaurants_coverage_kind_values" CHECK ("merchants"."restaurants"."coverage_kind" IN ('radius', 'zones')),
	CONSTRAINT "restaurants_coverage_radius" CHECK (("merchants"."restaurants"."coverage_kind" = 'radius') = ("merchants"."restaurants"."coverage_radius_metres" IS NOT NULL) AND "merchants"."restaurants"."coverage_radius_metres" > 0),
	CONSTRAINT "restaurants_minimum_order" CHECK ("merchants"."restaurants"."minimum_order" >= 0),
	CONSTRAINT "restaurants_default_prep_min" CHECK ("merchants"."restaurants"."default_prep_min" > 0),
	CONSTRAINT "restaurants_max_active_orders" CHECK ("merchants"."restaurants"."max_active_orders" BETWEEN 1 AND 50),
	CONSTRAINT "restaurants_busy_mode" CHECK (("merchants"."restaurants"."busy_extra_min" IS NULL) = ("merchants"."restaurants"."busy_until" IS NULL) AND "merchants"."restaurants"."busy_extra_min" > 0)
);
--> statement-breakpoint
CREATE TABLE "merchants"."weekly_schedules" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"changed_by_type" text NOT NULL,
	"changed_by_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "weekly_schedules_changed_by_type_values" CHECK ("merchants"."weekly_schedules"."changed_by_type" IN ('admin', 'merchant', 'system'))
);
--> statement-breakpoint
ALTER TABLE "merchants"."categories" ADD CONSTRAINT "categories_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."change_requests" ADD CONSTRAINT "change_requests_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."commission_rates" ADD CONSTRAINT "commission_rates_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."coverage_zones" ADD CONSTRAINT "coverage_zones_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."holiday_closes" ADD CONSTRAINT "holiday_closes_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."item_option_groups" ADD CONSTRAINT "item_option_groups_item_id_items_id_fk" FOREIGN KEY ("item_id") REFERENCES "merchants"."items"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."item_option_groups" ADD CONSTRAINT "item_option_groups_group_id_option_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "merchants"."option_groups"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."items" ADD CONSTRAINT "items_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."items" ADD CONSTRAINT "items_category_id_categories_id_fk" FOREIGN KEY ("category_id") REFERENCES "merchants"."categories"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."opening_periods" ADD CONSTRAINT "opening_periods_schedule_id_weekly_schedules_id_fk" FOREIGN KEY ("schedule_id") REFERENCES "merchants"."weekly_schedules"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."option_groups" ADD CONSTRAINT "option_groups_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."options" ADD CONSTRAINT "options_group_id_option_groups_id_fk" FOREIGN KEY ("group_id") REFERENCES "merchants"."option_groups"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."pauses" ADD CONSTRAINT "pauses_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."price_changes" ADD CONSTRAINT "price_changes_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."price_changes" ADD CONSTRAINT "price_changes_item_id_items_id_fk" FOREIGN KEY ("item_id") REFERENCES "merchants"."items"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."price_changes" ADD CONSTRAINT "price_changes_option_id_options_id_fk" FOREIGN KEY ("option_id") REFERENCES "merchants"."options"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "merchants"."weekly_schedules" ADD CONSTRAINT "weekly_schedules_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "categories_restaurant" ON "merchants"."categories" USING btree ("restaurant_id","position");--> statement-breakpoint
CREATE UNIQUE INDEX "change_requests_one_pending" ON "merchants"."change_requests" USING btree ("target_type","target_id","field") WHERE "merchants"."change_requests"."status" = 'pending';--> statement-breakpoint
CREATE INDEX "change_requests_queue" ON "merchants"."change_requests" USING btree ("status","created_at");--> statement-breakpoint
CREATE INDEX "change_requests_restaurant" ON "merchants"."change_requests" USING btree ("restaurant_id","status");--> statement-breakpoint
CREATE INDEX "commission_rates_restaurant" ON "merchants"."commission_rates" USING btree ("restaurant_id","effective_from");--> statement-breakpoint
CREATE INDEX "coverage_zones_zone" ON "merchants"."coverage_zones" USING btree ("zone_id");--> statement-breakpoint
CREATE INDEX "holiday_closes_restaurant" ON "merchants"."holiday_closes" USING btree ("restaurant_id","ends_at");--> statement-breakpoint
CREATE INDEX "item_option_groups_group" ON "merchants"."item_option_groups" USING btree ("group_id");--> statement-breakpoint
CREATE INDEX "items_category" ON "merchants"."items" USING btree ("category_id","position");--> statement-breakpoint
CREATE INDEX "option_groups_restaurant" ON "merchants"."option_groups" USING btree ("restaurant_id");--> statement-breakpoint
CREATE INDEX "options_group" ON "merchants"."options" USING btree ("group_id","position");--> statement-breakpoint
CREATE INDEX "pauses_restaurant" ON "merchants"."pauses" USING btree ("restaurant_id","starts_at" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "price_changes_restaurant" ON "merchants"."price_changes" USING btree ("restaurant_id","id" DESC NULLS LAST);--> statement-breakpoint
CREATE INDEX "price_changes_item" ON "merchants"."price_changes" USING btree ("item_id");--> statement-breakpoint
CREATE INDEX "price_changes_option" ON "merchants"."price_changes" USING btree ("option_id");--> statement-breakpoint
CREATE INDEX "restaurants_city" ON "merchants"."restaurants" USING btree ("city_id");--> statement-breakpoint
CREATE INDEX "restaurants_location" ON "merchants"."restaurants" USING gist ("location");--> statement-breakpoint
CREATE INDEX "weekly_schedules_current" ON "merchants"."weekly_schedules" USING btree ("restaurant_id","id" DESC NULLS LAST);--> statement-breakpoint
-- Versions and logs are never changed: the schedule versions with their
-- periods, the commission versions and the price log.
REVOKE UPDATE ON "merchants"."weekly_schedules", "merchants"."opening_periods", "merchants"."commission_rates", "merchants"."price_changes" FROM fox_drop_app;
