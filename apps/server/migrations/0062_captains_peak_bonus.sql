CREATE TABLE "captains"."peak_bonus_versions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"enabled" boolean NOT NULL,
	"currency" text NOT NULL,
	"effective_from" timestamp with time zone NOT NULL,
	"editor_type" text NOT NULL,
	"editor_id" uuid,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "peak_bonus_versions_editor_type_values" CHECK ("captains"."peak_bonus_versions"."editor_type" IN ('admin', 'system')),
	CONSTRAINT "peak_bonus_versions_editor" CHECK (("captains"."peak_bonus_versions"."editor_type" = 'system') = ("captains"."peak_bonus_versions"."editor_id" IS NULL)),
	CONSTRAINT "peak_bonus_versions_start" CHECK ("captains"."peak_bonus_versions"."effective_from" >= "captains"."peak_bonus_versions"."created_at")
);
--> statement-breakpoint
CREATE TABLE "captains"."peak_bonus_windows" (
	"version_id" uuid NOT NULL,
	"position" integer NOT NULL,
	"days" integer[] NOT NULL,
	"start_minute" integer NOT NULL,
	"end_minute" integer NOT NULL,
	"amount" bigint NOT NULL,
	"zone_ids" uuid[] NOT NULL,
	CONSTRAINT "peak_bonus_windows_version_id_position_pk" PRIMARY KEY("version_id","position"),
	CONSTRAINT "peak_bonus_windows_values" CHECK (cardinality("captains"."peak_bonus_windows"."days") > 0 AND "captains"."peak_bonus_windows"."days" <@ ARRAY[1, 2, 3, 4, 5, 6, 7]
          AND "captains"."peak_bonus_windows"."start_minute" BETWEEN 0 AND 1439 AND "captains"."peak_bonus_windows"."end_minute" BETWEEN 0 AND 1439
          AND "captains"."peak_bonus_windows"."start_minute" <> "captains"."peak_bonus_windows"."end_minute" AND "captains"."peak_bonus_windows"."amount" > 0)
);
--> statement-breakpoint
ALTER TABLE "captains"."peak_bonus_windows" ADD CONSTRAINT "peak_bonus_windows_version_id_peak_bonus_versions_id_fk" FOREIGN KEY ("version_id") REFERENCES "captains"."peak_bonus_versions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "peak_bonus_versions_city" ON "captains"."peak_bonus_versions" USING btree ("city_id","created_at","id");--> statement-breakpoint
REVOKE UPDATE ON "captains"."peak_bonus_versions", "captains"."peak_bonus_windows" FROM fox_drop_app;
