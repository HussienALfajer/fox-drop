CREATE SCHEMA "marketing";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "marketing" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "marketing" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "marketing" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "marketing"."idempotency_keys" (
	"account_id" uuid NOT NULL,
	"key" text NOT NULL,
	"request_hash" text NOT NULL,
	"code_ids" uuid[] NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "idempotency_keys_account_id_key_pk" PRIMARY KEY("account_id","key")
);
--> statement-breakpoint
CREATE TABLE "marketing"."promo_codes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"code" text NOT NULL,
	"batch_id" uuid,
	"kind" text NOT NULL,
	"percent_bp" integer,
	"amount" bigint,
	"max_discount" bigint,
	"currency" text NOT NULL,
	"min_order" bigint,
	"valid_from" timestamp with time zone NOT NULL,
	"valid_to" timestamp with time zone NOT NULL,
	"start_minute" integer,
	"end_minute" integer,
	"total_limit" integer,
	"per_customer_limit" integer,
	"audience" text NOT NULL,
	"restaurant_ids" uuid[] NOT NULL,
	"zone_ids" uuid[] NOT NULL,
	"funding" text NOT NULL,
	"merchant_share_bp" integer NOT NULL,
	"daily_budget" bigint,
	"visibility" text NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_by" uuid NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "promo_codes_code_format" CHECK ("marketing"."promo_codes"."code" ~ '^[A-Z0-9]{3,20}$'),
	CONSTRAINT "promo_codes_kind_values" CHECK ("marketing"."promo_codes"."kind" IN ('percentage', 'fixed_amount', 'free_delivery')),
	CONSTRAINT "promo_codes_value" CHECK (COALESCE(CASE "marketing"."promo_codes"."kind"
            WHEN 'percentage' THEN "marketing"."promo_codes"."percent_bp" BETWEEN 1 AND 10000 AND "marketing"."promo_codes"."amount" IS NULL
              AND ("marketing"."promo_codes"."max_discount" IS NULL OR "marketing"."promo_codes"."max_discount" > 0)
            WHEN 'fixed_amount' THEN "marketing"."promo_codes"."amount" > 0 AND "marketing"."promo_codes"."percent_bp" IS NULL
              AND "marketing"."promo_codes"."max_discount" IS NULL
            ELSE "marketing"."promo_codes"."percent_bp" IS NULL AND "marketing"."promo_codes"."amount" IS NULL AND "marketing"."promo_codes"."max_discount" IS NULL
          END, false)),
	CONSTRAINT "promo_codes_currency" CHECK ("marketing"."promo_codes"."currency" ~ '^[A-Z]{3}$'),
	CONSTRAINT "promo_codes_amounts" CHECK (("marketing"."promo_codes"."min_order" IS NULL OR "marketing"."promo_codes"."min_order" > 0)
          AND ("marketing"."promo_codes"."daily_budget" IS NULL OR "marketing"."promo_codes"."daily_budget" > 0)),
	CONSTRAINT "promo_codes_validity" CHECK ("marketing"."promo_codes"."valid_to" > "marketing"."promo_codes"."valid_from"),
	CONSTRAINT "promo_codes_hours" CHECK (("marketing"."promo_codes"."start_minute" IS NULL) = ("marketing"."promo_codes"."end_minute" IS NULL)
          AND ("marketing"."promo_codes"."start_minute" IS NULL OR ("marketing"."promo_codes"."start_minute" BETWEEN 0 AND 1439
            AND "marketing"."promo_codes"."end_minute" BETWEEN 0 AND 1439 AND "marketing"."promo_codes"."start_minute" <> "marketing"."promo_codes"."end_minute"))),
	CONSTRAINT "promo_codes_limits" CHECK (("marketing"."promo_codes"."total_limit" IS NULL OR "marketing"."promo_codes"."total_limit" > 0)
          AND ("marketing"."promo_codes"."per_customer_limit" IS NULL OR "marketing"."promo_codes"."per_customer_limit" > 0)
          AND ("marketing"."promo_codes"."total_limit" IS NULL OR "marketing"."promo_codes"."per_customer_limit" IS NULL
            OR "marketing"."promo_codes"."per_customer_limit" <= "marketing"."promo_codes"."total_limit")),
	CONSTRAINT "promo_codes_audience_values" CHECK ("marketing"."promo_codes"."audience" IN ('everyone', 'new_users')),
	CONSTRAINT "promo_codes_funding" CHECK (CASE "marketing"."promo_codes"."funding"
            WHEN 'platform' THEN "marketing"."promo_codes"."merchant_share_bp" = 0
            WHEN 'restaurant' THEN "marketing"."promo_codes"."merchant_share_bp" = 10000
              AND cardinality("marketing"."promo_codes"."restaurant_ids") > 0
            WHEN 'shared' THEN "marketing"."promo_codes"."merchant_share_bp" BETWEEN 1 AND 9999
              AND cardinality("marketing"."promo_codes"."restaurant_ids") > 0
            ELSE false
          END),
	CONSTRAINT "promo_codes_visibility_values" CHECK ("marketing"."promo_codes"."visibility" IN ('visible', 'secret')),
	CONSTRAINT "promo_codes_status_values" CHECK ("marketing"."promo_codes"."status" IN ('active', 'paused'))
);
--> statement-breakpoint
CREATE UNIQUE INDEX "promo_codes_city_code" ON "marketing"."promo_codes" USING btree ("city_id","code");--> statement-breakpoint
CREATE INDEX "promo_codes_batch" ON "marketing"."promo_codes" USING btree ("batch_id");