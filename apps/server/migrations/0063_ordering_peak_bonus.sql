ALTER TABLE "ordering"."collections" ADD COLUMN "peak_bonus" bigint DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "ordering"."collections" ADD COLUMN "peak_bonus_version_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."collections" ADD CONSTRAINT "collections_peak_bonus" CHECK ("ordering"."collections"."peak_bonus" >= 0 AND ("ordering"."collections"."peak_bonus" > 0) = ("ordering"."collections"."peak_bonus_version_id" IS NOT NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "ordering"."collections" VALIDATE CONSTRAINT "collections_peak_bonus";
