CREATE TABLE "marketing"."late_codes" (
	"order_id" uuid PRIMARY KEY NOT NULL,
	"city_id" uuid NOT NULL,
	"order_number" bigint NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"code_id" uuid NOT NULL,
	"promised_at" timestamp with time zone NOT NULL,
	"issued_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" DROP CONSTRAINT "promo_codes_personal";--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ALTER COLUMN "created_by" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ALTER COLUMN "updated_by" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "marketing"."late_codes" ADD CONSTRAINT "late_codes_code_id_promo_codes_id_fk" FOREIGN KEY ("code_id") REFERENCES "marketing"."promo_codes"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "late_codes_code" ON "marketing"."late_codes" USING btree ("code_id");--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ADD CONSTRAINT "promo_codes_admins" CHECK ("marketing"."promo_codes"."visibility" = 'personal'
          OR ("marketing"."promo_codes"."created_by" IS NOT NULL AND "marketing"."promo_codes"."updated_by" IS NOT NULL));--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ADD CONSTRAINT "promo_codes_personal" CHECK (("marketing"."promo_codes"."visibility" = 'personal') = ("marketing"."promo_codes"."customer_account_id" IS NOT NULL)
          AND ("marketing"."promo_codes"."visibility" <> 'personal' OR ("marketing"."promo_codes"."kind" <> 'free_delivery'
            AND "marketing"."promo_codes"."total_limit" = 1 AND "marketing"."promo_codes"."per_customer_limit" = 1
            AND "marketing"."promo_codes"."audience" = 'everyone' AND "marketing"."promo_codes"."funding" = 'platform'
            AND cardinality("marketing"."promo_codes"."restaurant_ids") = 0 AND cardinality("marketing"."promo_codes"."zone_ids") = 0
            AND "marketing"."promo_codes"."min_order" IS NULL AND "marketing"."promo_codes"."daily_budget" IS NULL
            AND "marketing"."promo_codes"."start_minute" IS NULL AND "marketing"."promo_codes"."batch_id" IS NULL)));--> statement-breakpoint
-- A late code is never changed (slice 2.22c).
REVOKE UPDATE ON "marketing"."late_codes" FROM fox_drop_app;
