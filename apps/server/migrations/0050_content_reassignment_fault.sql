ALTER TABLE "content"."reasons" ADD COLUMN "captain_fault" boolean;--> statement-breakpoint
-- AP Appendix B, owner decision 2026-11-10: each reassignment reason's
-- default fault, which the dialog prefills and the admin may change.
UPDATE "content"."reasons" SET "captain_fault" = ("code" IN ('captain_request', 'captain_late')) WHERE "list" = 'reassignment';--> statement-breakpoint
ALTER TABLE "content"."reasons" ADD CONSTRAINT "reasons_captain_fault" CHECK (("content"."reasons"."list" = 'reassignment') = ("content"."reasons"."captain_fault" IS NOT NULL));
