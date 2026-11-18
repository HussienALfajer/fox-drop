ALTER TABLE "merchants"."restaurants" ADD COLUMN "activated_at" timestamp with time zone;--> statement-breakpoint
-- Slice 2.27b: a restaurant already active or once active takes the time of
-- its first change to active in the audit log; none found leaves it null
-- (never «جديد على FOX DROP»).
UPDATE "merchants"."restaurants" AS "r"
SET "activated_at" = "first"."at"
FROM (
	SELECT "target_id", min("occurred_at") AS "at"
	FROM "audit"."events"
	WHERE "action" = 'restaurant.status'
		AND "target_type" = 'restaurant'
		AND "changes" -> 'accountStatus' ->> 'after' = 'active'
	GROUP BY "target_id"
) AS "first"
WHERE "first"."target_id" = "r"."id"::text;
