ALTER TABLE "marketing"."promo_code_uses" ADD COLUMN "new_user" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "marketing"."promo_code_uses" ADD COLUMN "delivered" boolean DEFAULT false NOT NULL;--> statement-breakpoint
CREATE INDEX "promo_code_uses_customer_held" ON "marketing"."promo_code_uses" USING btree ("customer_account_id","held_at");