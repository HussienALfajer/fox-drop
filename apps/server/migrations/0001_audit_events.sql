CREATE SCHEMA "audit";
--> statement-breakpoint
-- The audit log is append-only (AP §9.16, architecture §15.3): the application
-- role reads and adds rows, never changes or deletes one. The default
-- privileges reach every partition the migration role creates.
GRANT USAGE ON SCHEMA "audit" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "audit" GRANT SELECT, INSERT ON TABLES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "audit"."events" (
	"id" uuid DEFAULT uuidv7() NOT NULL,
	"occurred_at" timestamp with time zone DEFAULT now() NOT NULL,
	"city_id" uuid,
	"actor_type" text NOT NULL,
	"actor_id" uuid,
	"actor_role" text,
	"kind" text NOT NULL,
	"action" text NOT NULL,
	"target_type" text NOT NULL,
	"target_id" text NOT NULL,
	"changes" jsonb,
	"reason" text,
	"ip_address" "inet",
	"device" text,
	CONSTRAINT "events_id_occurred_at_pk" PRIMARY KEY("id","occurred_at"),
	CONSTRAINT "events_actor_type_values" CHECK ("audit"."events"."actor_type" IN ('admin', 'merchant', 'captain', 'customer', 'system')),
	CONSTRAINT "events_actor_id_present" CHECK (("audit"."events"."actor_type" = 'system') = ("audit"."events"."actor_id" IS NULL)),
	CONSTRAINT "events_kind_values" CHECK ("audit"."events"."kind" IN ('write', 'view')),
	CONSTRAINT "events_changes_on_writes_only" CHECK ("audit"."events"."kind" = 'write' OR "audit"."events"."changes" IS NULL)
) PARTITION BY RANGE ("occurred_at");
--> statement-breakpoint
-- One partition per UTC month (architecture §5.4), for this month and the
-- next. It runs as the migration role, which owns it, so the partitions it
-- creates get the schema's default privileges; the application role may call
-- it but cannot create a partition itself. The audit module calls it at start
-- and every day.
CREATE FUNCTION "audit"."create_month_partitions"() RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, pg_temp AS $$
DECLARE
	month_start timestamp;
BEGIN
	-- Two servers starting together create each partition once.
	PERFORM pg_advisory_xact_lock(hashtext('audit.create_month_partitions'));
	FOR offset_months IN 0..1 LOOP
		month_start := date_trunc('month', now() AT TIME ZONE 'UTC') + make_interval(months => offset_months);
		EXECUTE format(
			'CREATE TABLE IF NOT EXISTS audit.%I PARTITION OF audit.events FOR VALUES FROM (%L) TO (%L)',
			'events_' || to_char(month_start, 'YYYY_MM'),
			month_start AT TIME ZONE 'UTC',
			(month_start + interval '1 month') AT TIME ZONE 'UTC'
		);
	END LOOP;
END;
$$;
--> statement-breakpoint
REVOKE EXECUTE ON FUNCTION "audit"."create_month_partitions"() FROM PUBLIC;
--> statement-breakpoint
GRANT EXECUTE ON FUNCTION "audit"."create_month_partitions"() TO fox_drop_app;
--> statement-breakpoint
SELECT "audit"."create_month_partitions"();
