CREATE TABLE "identity"."windows_devices" (
	"device_id" uuid PRIMARY KEY NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"public_key" text NOT NULL,
	"pairing_id" uuid NOT NULL,
	"registered_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "identity"."windows_pairings" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"city_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"created_by" uuid NOT NULL,
	"code_hash" text NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"used_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "identity"."windows_devices" ADD CONSTRAINT "windows_devices_pairing_id_windows_pairings_id_fk" FOREIGN KEY ("pairing_id") REFERENCES "identity"."windows_pairings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."windows_pairings" ADD CONSTRAINT "windows_pairings_created_by_merchant_accounts_id_fk" FOREIGN KEY ("created_by") REFERENCES "identity"."merchant_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "windows_pairings_code" ON "identity"."windows_pairings" USING btree ("code_hash");