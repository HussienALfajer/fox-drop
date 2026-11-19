ALTER TABLE "identity"."captain_accounts" ALTER COLUMN "city_id" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "identity"."captain_accounts" ALTER COLUMN "captain_id" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "identity"."captain_accounts" ADD CONSTRAINT "captain_accounts_applicant" CHECK (("identity"."captain_accounts"."captain_id" IS NULL) = ("identity"."captain_accounts"."city_id" IS NULL)) NOT VALID;--> statement-breakpoint
ALTER TABLE "identity"."captain_accounts" VALIDATE CONSTRAINT "captain_accounts_applicant";
