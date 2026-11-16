CREATE TABLE "marketing"."compensations" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"order_id" uuid NOT NULL,
	"order_number" bigint NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"percent_bp" integer,
	"amount" bigint,
	"max_discount" bigint,
	"currency" text NOT NULL,
	"reason_code" text NOT NULL,
	"reason_label" text NOT NULL,
	"note" text,
	"status" text NOT NULL,
	"requested_by" uuid NOT NULL,
	"requested_at" timestamp with time zone NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	"decided_by" uuid,
	"decided_at" timestamp with time zone,
	"code_id" uuid,
	CONSTRAINT "compensations_kind_values" CHECK ("marketing"."compensations"."kind" IN ('fixed_amount', 'percentage')),
	CONSTRAINT "compensations_value" CHECK (COALESCE(CASE "marketing"."compensations"."kind"
            WHEN 'percentage' THEN "marketing"."compensations"."percent_bp" BETWEEN 1 AND 10000 AND "marketing"."compensations"."amount" IS NULL
              AND "marketing"."compensations"."max_discount" > 0
            ELSE "marketing"."compensations"."amount" > 0 AND "marketing"."compensations"."percent_bp" IS NULL AND "marketing"."compensations"."max_discount" IS NULL
          END, false)),
	CONSTRAINT "compensations_currency" CHECK ("marketing"."compensations"."currency" ~ '^[A-Z]{3}$'),
	CONSTRAINT "compensations_note" CHECK ("marketing"."compensations"."note" IS NULL OR char_length("marketing"."compensations"."note") BETWEEN 1 AND 300),
	CONSTRAINT "compensations_status_values" CHECK ("marketing"."compensations"."status" IN ('issued', 'waiting', 'rejected')),
	CONSTRAINT "compensations_state" CHECK (("marketing"."compensations"."status" = 'issued') = ("marketing"."compensations"."code_id" IS NOT NULL)
          AND ("marketing"."compensations"."decided_by" IS NULL) = ("marketing"."compensations"."decided_at" IS NULL)
          AND ("marketing"."compensations"."status" <> 'waiting' OR "marketing"."compensations"."decided_at" IS NULL)
          AND ("marketing"."compensations"."status" <> 'rejected' OR "marketing"."compensations"."decided_at" IS NOT NULL))
);
--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" DROP CONSTRAINT "promo_codes_visibility_values";--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ADD COLUMN "customer_account_id" uuid;--> statement-breakpoint
ALTER TABLE "marketing"."compensations" ADD CONSTRAINT "compensations_code_id_promo_codes_id_fk" FOREIGN KEY ("code_id") REFERENCES "marketing"."promo_codes"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "compensations_key" ON "marketing"."compensations" USING btree ("requested_by","idempotency_key");--> statement-breakpoint
CREATE INDEX "compensations_order" ON "marketing"."compensations" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "compensations_city_status" ON "marketing"."compensations" USING btree ("city_id","status");--> statement-breakpoint
CREATE INDEX "promo_codes_customer" ON "marketing"."promo_codes" USING btree ("customer_account_id");--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ADD CONSTRAINT "promo_codes_personal" CHECK (("marketing"."promo_codes"."visibility" = 'personal') = ("marketing"."promo_codes"."customer_account_id" IS NOT NULL)
          AND ("marketing"."promo_codes"."visibility" <> 'personal' OR ("marketing"."promo_codes"."kind" <> 'free_delivery'
            AND ("marketing"."promo_codes"."kind" <> 'percentage' OR "marketing"."promo_codes"."max_discount" IS NOT NULL)
            AND "marketing"."promo_codes"."total_limit" = 1 AND "marketing"."promo_codes"."per_customer_limit" = 1
            AND "marketing"."promo_codes"."audience" = 'everyone' AND "marketing"."promo_codes"."funding" = 'platform'
            AND cardinality("marketing"."promo_codes"."restaurant_ids") = 0 AND cardinality("marketing"."promo_codes"."zone_ids") = 0
            AND "marketing"."promo_codes"."min_order" IS NULL AND "marketing"."promo_codes"."daily_budget" IS NULL
            AND "marketing"."promo_codes"."start_minute" IS NULL AND "marketing"."promo_codes"."batch_id" IS NULL)));--> statement-breakpoint
ALTER TABLE "marketing"."promo_codes" ADD CONSTRAINT "promo_codes_visibility_values" CHECK ("marketing"."promo_codes"."visibility" IN ('visible', 'secret', 'personal'));