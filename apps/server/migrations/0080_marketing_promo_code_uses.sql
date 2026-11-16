CREATE TABLE "marketing"."promo_code_uses" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"code_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"phone_hash" text NOT NULL,
	"device_id" text NOT NULL,
	"business_day" timestamp with time zone NOT NULL,
	"currency" text NOT NULL,
	"discount" bigint NOT NULL,
	"merchant_share" bigint NOT NULL,
	"status" text DEFAULT 'held' NOT NULL,
	"held_at" timestamp with time zone NOT NULL,
	"settled_at" timestamp with time zone,
	CONSTRAINT "promo_code_uses_status_values" CHECK ("marketing"."promo_code_uses"."status" IN ('held', 'spent', 'returned')),
	CONSTRAINT "promo_code_uses_money" CHECK ("marketing"."promo_code_uses"."discount" >= 0 AND "marketing"."promo_code_uses"."merchant_share" >= 0 AND "marketing"."promo_code_uses"."merchant_share" <= "marketing"."promo_code_uses"."discount"),
	CONSTRAINT "promo_code_uses_settled" CHECK (("marketing"."promo_code_uses"."status" = 'held') = ("marketing"."promo_code_uses"."settled_at" IS NULL))
);
--> statement-breakpoint
ALTER TABLE "marketing"."promo_code_uses" ADD CONSTRAINT "promo_code_uses_code_id_promo_codes_id_fk" FOREIGN KEY ("code_id") REFERENCES "marketing"."promo_codes"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "promo_code_uses_order" ON "marketing"."promo_code_uses" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "promo_code_uses_code_day" ON "marketing"."promo_code_uses" USING btree ("code_id","business_day");--> statement-breakpoint
CREATE INDEX "promo_code_uses_code_customer" ON "marketing"."promo_code_uses" USING btree ("code_id","customer_account_id");