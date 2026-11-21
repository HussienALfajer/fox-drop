ALTER TABLE "customers"."addresses" ADD COLUMN "idempotency_key" text;--> statement-breakpoint
ALTER TABLE "customers"."addresses" ADD COLUMN "request_hash" text;--> statement-breakpoint
CREATE UNIQUE INDEX "addresses_key" ON "customers"."addresses" USING btree ("account_id","idempotency_key") WHERE "customers"."addresses"."idempotency_key" IS NOT NULL;--> statement-breakpoint
ALTER TABLE "customers"."addresses" ADD CONSTRAINT "addresses_key_hash" CHECK (("customers"."addresses"."idempotency_key" IS NULL) = ("customers"."addresses"."request_hash" IS NULL));