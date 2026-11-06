CREATE SCHEMA "ordering";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "ordering" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "ordering" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "ordering" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "ordering"."idempotency_keys" (
	"account_id" uuid NOT NULL,
	"key" text NOT NULL,
	"request_hash" text NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "idempotency_keys_account_id_key_pk" PRIMARY KEY("account_id","key")
);
--> statement-breakpoint
CREATE TABLE "ordering"."order_events" (
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"version" integer NOT NULL,
	"city_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"from_status" text,
	"to_status" text NOT NULL,
	"actor_type" text NOT NULL,
	"actor_id" uuid,
	"reason" text,
	CONSTRAINT "order_events_order_id_order_placed_at_version_pk" PRIMARY KEY("order_id","order_placed_at","version"),
	CONSTRAINT "order_events_status_values" CHECK (("ordering"."order_events"."from_status" IS NULL OR "ordering"."order_events"."from_status" IN ('placed', 'accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'rejected', 'cancelled', 'failed')) AND "ordering"."order_events"."to_status" IN ('placed', 'accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'rejected', 'cancelled', 'failed')),
	CONSTRAINT "order_events_actor_values" CHECK ("ordering"."order_events"."actor_type" IN ('customer', 'restaurant', 'captain', 'admin', 'system'))
) PARTITION BY RANGE ("order_placed_at");
--> statement-breakpoint
CREATE TABLE "ordering"."order_lines" (
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"position" smallint NOT NULL,
	"city_id" uuid NOT NULL,
	"item_id" uuid NOT NULL,
	"item_name" text NOT NULL,
	"quantity" smallint NOT NULL,
	"options" jsonb NOT NULL,
	"unit_price" bigint NOT NULL,
	"line_total" bigint NOT NULL,
	"note" text,
	CONSTRAINT "order_lines_order_id_order_placed_at_position_pk" PRIMARY KEY("order_id","order_placed_at","position"),
	CONSTRAINT "order_lines_quantity" CHECK ("ordering"."order_lines"."quantity" BETWEEN 1 AND 20),
	CONSTRAINT "order_lines_money" CHECK ("ordering"."order_lines"."unit_price" >= 0 AND "ordering"."order_lines"."line_total" = "ordering"."order_lines"."unit_price" * "ordering"."order_lines"."quantity")
) PARTITION BY RANGE ("order_placed_at");
--> statement-breakpoint
CREATE TABLE "ordering"."order_numbers" (
	"city_id" uuid PRIMARY KEY NOT NULL,
	"last_number" bigint NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ordering"."orders" (
	"id" uuid DEFAULT uuidv7() NOT NULL,
	"placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"number" bigint NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"status" text NOT NULL,
	"version" integer NOT NULL,
	"currency" text NOT NULL,
	"items_value" bigint NOT NULL,
	"delivery_fee" bigint NOT NULL,
	"discount" bigint NOT NULL,
	"rounding" bigint NOT NULL,
	"total" bigint NOT NULL,
	"delivery_free" boolean NOT NULL,
	"fee_rule_id" uuid NOT NULL,
	"commission_bp" integer NOT NULL,
	"pay_table_id" uuid,
	"rate_snapshot" jsonb NOT NULL,
	"pay_in" text,
	"note" text,
	"estimate_from_min" smallint NOT NULL,
	"estimate_to_min" smallint NOT NULL,
	"address_id" uuid,
	"location" geometry(Point,4326) NOT NULL,
	"zone_id" uuid NOT NULL,
	"neighbourhood" text NOT NULL,
	"label" text,
	"custom_label" text,
	"street" text NOT NULL,
	"floor" text,
	"landmark" text NOT NULL,
	"contact_phone_encrypted" text,
	"recipient_name" text,
	"directions" text,
	CONSTRAINT "orders_id_placed_at_pk" PRIMARY KEY("id","placed_at"),
	CONSTRAINT "orders_status_values" CHECK ("ordering"."orders"."status" IN ('placed', 'accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'rejected', 'cancelled', 'failed')),
	CONSTRAINT "orders_version" CHECK ("ordering"."orders"."version" >= 1),
	CONSTRAINT "orders_money" CHECK ("ordering"."orders"."items_value" >= 0 AND "ordering"."orders"."delivery_fee" >= 0 AND "ordering"."orders"."discount" >= 0 AND "ordering"."orders"."total" >= 0 AND "ordering"."orders"."total" = "ordering"."orders"."items_value" + "ordering"."orders"."delivery_fee" - "ordering"."orders"."discount" + "ordering"."orders"."rounding"),
	CONSTRAINT "orders_note" CHECK (char_length("ordering"."orders"."note") BETWEEN 1 AND 200),
	CONSTRAINT "orders_label_values" CHECK ("ordering"."orders"."label" IS NULL OR "ordering"."orders"."label" IN ('home', 'work', 'other')),
	CONSTRAINT "orders_recipient" CHECK ("ordering"."orders"."contact_phone_encrypted" IS NULL OR "ordering"."orders"."recipient_name" IS NOT NULL)
) PARTITION BY RANGE ("placed_at");
--> statement-breakpoint
ALTER TABLE "ordering"."order_events" ADD CONSTRAINT "order_events_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ordering"."order_lines" ADD CONSTRAINT "order_lines_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "orders_city_number" ON "ordering"."orders" USING btree ("city_id","number");--> statement-breakpoint
CREATE INDEX "orders_customer_status" ON "ordering"."orders" USING btree ("customer_account_id","status");--> statement-breakpoint
CREATE INDEX "orders_restaurant_status" ON "ordering"."orders" USING btree ("restaurant_id","status");--> statement-breakpoint
-- Append-only (architecture §5.5): the ordering schema grants UPDATE by
-- default, so it is revoked on the order events here and on every partition
-- when it is created.
REVOKE UPDATE ON "ordering"."order_events" FROM fox_drop_app;
--> statement-breakpoint
-- One partition per UTC month of placing (architecture §5.4) for the orders,
-- their lines and their events, this month's and the next: an order is
-- placed now, and its lines and events go with it. It runs as the migration
-- role, which owns it, as captains.create_month_partitions does; the worker
-- calls it at start and every day.
CREATE FUNCTION "ordering"."create_month_partitions"() RETURNS void
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
SET "TimeZone" = 'UTC'
SET "DateStyle" = 'ISO'
SET lock_timeout = '5s'
AS $$
DECLARE
	month_start timestamp;
	suffix text;
	parent text;
BEGIN
	-- Two servers starting together create each partition once.
	PERFORM pg_advisory_xact_lock(hashtext('ordering.create_month_partitions'));
	FOR offset_months IN 0..1 LOOP
		month_start := date_trunc('month', now() AT TIME ZONE 'UTC') + make_interval(months => offset_months);
		suffix := '_' || to_char(month_start, 'YYYY_MM');
		-- The orders first: the lines and events reference them.
		FOREACH parent IN ARRAY ARRAY['orders', 'order_lines', 'order_events'] LOOP
			EXECUTE format(
				'CREATE TABLE IF NOT EXISTS ordering.%I PARTITION OF ordering.%I FOR VALUES FROM (%L) TO (%L)',
				parent || suffix,
				parent,
				month_start AT TIME ZONE 'UTC',
				(month_start + interval '1 month') AT TIME ZONE 'UTC'
			);
		END LOOP;
		EXECUTE format('REVOKE UPDATE ON ordering.%I FROM fox_drop_app', 'order_events' || suffix);
	END LOOP;
END;
$$;
--> statement-breakpoint
REVOKE EXECUTE ON FUNCTION "ordering"."create_month_partitions"() FROM PUBLIC;
--> statement-breakpoint
GRANT EXECUTE ON FUNCTION "ordering"."create_month_partitions"() TO fox_drop_app;
--> statement-breakpoint
SELECT "ordering"."create_month_partitions"();
