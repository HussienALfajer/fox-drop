CREATE TABLE "identity"."app_refresh_tokens" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"session_id" uuid NOT NULL,
	"token_hash" text NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"used_at" timestamp with time zone,
	CONSTRAINT "app_refresh_tokens_token_hash_unique" UNIQUE("token_hash")
);
--> statement-breakpoint
CREATE TABLE "identity"."app_sessions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"party" text NOT NULL,
	"account_id" uuid NOT NULL,
	"device_id" text NOT NULL,
	"user_agent" text,
	"ip_address" "inet",
	"signed_in_at" timestamp with time zone NOT NULL,
	"last_refreshed_at" timestamp with time zone NOT NULL,
	"ended_at" timestamp with time zone,
	"end_reason" text,
	CONSTRAINT "app_sessions_party_values" CHECK ("identity"."app_sessions"."party" IN ('customer')),
	CONSTRAINT "app_sessions_end_reason_values" CHECK ("identity"."app_sessions"."end_reason" IN ('sign_out', 'sign_out_everywhere', 'refresh_reuse', 'new_sign_in')),
	CONSTRAINT "app_sessions_ended_with_reason" CHECK (("identity"."app_sessions"."ended_at" IS NULL) = ("identity"."app_sessions"."end_reason" IS NULL))
);
--> statement-breakpoint
CREATE TABLE "identity"."app_sign_in_codes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"party" text NOT NULL,
	"phone_hash" text NOT NULL,
	"device_id" text NOT NULL,
	"code_hash" text NOT NULL,
	"attempts" integer DEFAULT 0 NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"ended_at" timestamp with time zone,
	"end_reason" text,
	CONSTRAINT "app_sign_in_codes_party_values" CHECK ("identity"."app_sign_in_codes"."party" IN ('customer')),
	CONSTRAINT "app_sign_in_codes_end_reason_values" CHECK ("identity"."app_sign_in_codes"."end_reason" IN ('used', 'replaced', 'attempts_exhausted')),
	CONSTRAINT "app_sign_in_codes_ended_with_reason" CHECK (("identity"."app_sign_in_codes"."ended_at" IS NULL) = ("identity"."app_sign_in_codes"."end_reason" IS NULL))
);
--> statement-breakpoint
CREATE TABLE "identity"."app_signing_keys" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"private_key_encrypted" text NOT NULL,
	"public_key" text NOT NULL,
	"created_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "identity"."customer_accounts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"phone_encrypted" text NOT NULL,
	"phone_hash" text NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "customer_accounts_status_values" CHECK ("identity"."customer_accounts"."status" IN ('active'))
);
--> statement-breakpoint
ALTER TABLE "identity"."app_refresh_tokens" ADD CONSTRAINT "app_refresh_tokens_session_id_app_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "identity"."app_sessions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "app_refresh_tokens_session" ON "identity"."app_refresh_tokens" USING btree ("session_id");--> statement-breakpoint
CREATE INDEX "app_sessions_open_account" ON "identity"."app_sessions" USING btree ("party","account_id") WHERE "identity"."app_sessions"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "app_sessions_open_device" ON "identity"."app_sessions" USING btree ("party","device_id") WHERE "identity"."app_sessions"."ended_at" IS NULL;--> statement-breakpoint
CREATE UNIQUE INDEX "app_sign_in_codes_open_per_number" ON "identity"."app_sign_in_codes" USING btree ("phone_hash") WHERE "identity"."app_sign_in_codes"."ended_at" IS NULL;--> statement-breakpoint
CREATE INDEX "app_sign_in_codes_number_created" ON "identity"."app_sign_in_codes" USING btree ("phone_hash","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "customer_accounts_active_phone" ON "identity"."customer_accounts" USING btree ("phone_hash") WHERE "identity"."customer_accounts"."status" = 'active';