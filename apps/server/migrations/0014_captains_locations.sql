CREATE TABLE "captains"."locations" (
	"captain_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"recorded_at" timestamp with time zone NOT NULL,
	"received_at" timestamp with time zone NOT NULL,
	"location" geometry(Point,4326) NOT NULL,
	"accuracy_metres" real NOT NULL,
	"simulated" boolean NOT NULL,
	CONSTRAINT "locations_captain_id_recorded_at_pk" PRIMARY KEY("captain_id","recorded_at"),
	CONSTRAINT "locations_accuracy" CHECK ("captains"."locations"."accuracy_metres" >= 0)
) PARTITION BY RANGE ("recorded_at");
--> statement-breakpoint
-- Append-only: the captains schema grants UPDATE by default, so it is
-- revoked here and on every partition when it is created.
REVOKE UPDATE ON "captains"."locations" FROM fox_drop_app;
--> statement-breakpoint
-- One partition per UTC month of the recorded time (architecture §5.4), for
-- the last month, this month and the next: a point queued without a signal
-- may arrive after its month ended. It runs as the migration role, which owns
-- it, as ledger.create_month_partitions does; the worker calls it at start and
-- every day.
CREATE FUNCTION "captains"."create_month_partitions"() RETURNS void
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
SET "TimeZone" = 'UTC'
SET "DateStyle" = 'ISO'
SET lock_timeout = '5s'
AS $$
DECLARE
	month_start timestamp;
	partition_name text;
BEGIN
	-- Two servers starting together create each partition once.
	PERFORM pg_advisory_xact_lock(hashtext('captains.create_month_partitions'));
	FOR offset_months IN -1..1 LOOP
		month_start := date_trunc('month', now() AT TIME ZONE 'UTC') + make_interval(months => offset_months);
		partition_name := 'locations_' || to_char(month_start, 'YYYY_MM');
		EXECUTE format(
			'CREATE TABLE IF NOT EXISTS captains.%I PARTITION OF captains.locations FOR VALUES FROM (%L) TO (%L)',
			partition_name,
			month_start AT TIME ZONE 'UTC',
			(month_start + interval '1 month') AT TIME ZONE 'UTC'
		);
		EXECUTE format('REVOKE UPDATE ON captains.%I FROM fox_drop_app', partition_name);
	END LOOP;
END;
$$;
--> statement-breakpoint
REVOKE EXECUTE ON FUNCTION "captains"."create_month_partitions"() FROM PUBLIC;
--> statement-breakpoint
GRANT EXECUTE ON FUNCTION "captains"."create_month_partitions"() TO fox_drop_app;
--> statement-breakpoint
SELECT "captains"."create_month_partitions"();
