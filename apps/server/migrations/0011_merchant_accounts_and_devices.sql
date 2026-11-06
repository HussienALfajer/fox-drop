CREATE TABLE "identity"."merchant_accounts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"role" text NOT NULL,
	"name" text NOT NULL,
	"phone_encrypted" text NOT NULL,
	"phone_hash" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"removed_at" timestamp with time zone,
	CONSTRAINT "merchant_accounts_role_values" CHECK ("identity"."merchant_accounts"."role" IN ('owner', 'cashier'))
);
--> statement-breakpoint
CREATE TABLE "merchants"."devices" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"device_id" text NOT NULL,
	"name" text NOT NULL,
	"platform" text NOT NULL,
	"app_version" text NOT NULL,
	"named_by_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "devices_platform_values" CHECK ("merchants"."devices"."platform" IN ('android', 'ios', 'windows'))
);
--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" DROP CONSTRAINT "app_sessions_party_values";--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" DROP CONSTRAINT "app_sign_in_codes_party_values";--> statement-breakpoint
ALTER TABLE "merchants"."devices" ADD CONSTRAINT "devices_restaurant_id_restaurants_id_fk" FOREIGN KEY ("restaurant_id") REFERENCES "merchants"."restaurants"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "merchant_accounts_phone" ON "identity"."merchant_accounts" USING btree ("phone_hash") WHERE "identity"."merchant_accounts"."removed_at" IS NULL;--> statement-breakpoint
CREATE INDEX "merchant_accounts_restaurant" ON "identity"."merchant_accounts" USING btree ("restaurant_id");--> statement-breakpoint
CREATE UNIQUE INDEX "devices_restaurant_device" ON "merchants"."devices" USING btree ("restaurant_id","device_id");--> statement-breakpoint
ALTER TABLE "identity"."app_sessions" ADD CONSTRAINT "app_sessions_party_values" CHECK ("identity"."app_sessions"."party" IN ('customer', 'merchant'));--> statement-breakpoint
ALTER TABLE "identity"."app_sign_in_codes" ADD CONSTRAINT "app_sign_in_codes_party_values" CHECK ("identity"."app_sign_in_codes"."party" IN ('customer', 'merchant'));