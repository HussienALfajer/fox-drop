ALTER TABLE "ordering"."orders" ADD COLUMN "discount_merchant" bigint DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "promo_code_id" uuid;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "promo_code" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "promo_terms" jsonb;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_promo_code" CHECK (("promo_code_id" IS NULL) = ("promo_code" IS NULL) AND ("promo_code_id" IS NULL) = ("promo_terms" IS NULL) AND ("promo_code_id" IS NOT NULL OR "discount" = 0) AND "discount_merchant" BETWEEN 0 AND "discount");