CREATE SCHEMA "identity";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "identity" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "identity" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "identity" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "identity"."admin_accounts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"email" text,
	"phone_encrypted" text,
	"phone_hash" text,
	"roles" text[] NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"password_hash" text,
	"totp_secret_encrypted" text,
	"totp_last_step" bigint,
	"failed_attempts" integer DEFAULT 0 NOT NULL,
	"locked_until" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "admin_accounts_email_unique" UNIQUE("email"),
	CONSTRAINT "admin_accounts_phone_hash_unique" UNIQUE("phone_hash"),
	CONSTRAINT "admin_accounts_status_values" CHECK ("identity"."admin_accounts"."status" IN ('pending', 'active', 'disabled')),
	CONSTRAINT "admin_accounts_has_sign_in_name" CHECK ("identity"."admin_accounts"."email" IS NOT NULL OR "identity"."admin_accounts"."phone_hash" IS NOT NULL),
	CONSTRAINT "admin_accounts_phone_complete" CHECK (("identity"."admin_accounts"."phone_hash" IS NULL) = ("identity"."admin_accounts"."phone_encrypted" IS NULL)),
	CONSTRAINT "admin_accounts_active_is_set_up" CHECK ("identity"."admin_accounts"."status" <> 'active' OR ("identity"."admin_accounts"."password_hash" IS NOT NULL AND "identity"."admin_accounts"."totp_secret_encrypted" IS NOT NULL))
);
--> statement-breakpoint
CREATE TABLE "identity"."admin_backup_codes" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"code_hash" text NOT NULL,
	"used_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "identity"."admin_sessions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"token_hash" text NOT NULL,
	"user_agent" text,
	"ip_address" "inet",
	"signed_in_at" timestamp with time zone DEFAULT now() NOT NULL,
	"last_activity_at" timestamp with time zone DEFAULT now() NOT NULL,
	"ended_at" timestamp with time zone,
	"end_reason" text,
	CONSTRAINT "admin_sessions_token_hash_unique" UNIQUE("token_hash"),
	CONSTRAINT "admin_sessions_end_reason_values" CHECK ("identity"."admin_sessions"."end_reason" IN ('sign_out', 'idle', 'max_lifetime')),
	CONSTRAINT "admin_sessions_ended_with_reason" CHECK (("identity"."admin_sessions"."ended_at" IS NULL) = ("identity"."admin_sessions"."end_reason" IS NULL))
);
--> statement-breakpoint
CREATE TABLE "identity"."admin_setup_links" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"token_hash" text NOT NULL,
	"pending_totp_secret_encrypted" text,
	"expires_at" timestamp with time zone NOT NULL,
	"used_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "admin_setup_links_token_hash_unique" UNIQUE("token_hash")
);
--> statement-breakpoint
ALTER TABLE "identity"."admin_backup_codes" ADD CONSTRAINT "admin_backup_codes_account_id_admin_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "identity"."admin_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."admin_sessions" ADD CONSTRAINT "admin_sessions_account_id_admin_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "identity"."admin_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."admin_setup_links" ADD CONSTRAINT "admin_setup_links_account_id_admin_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "identity"."admin_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "admin_backup_codes_account" ON "identity"."admin_backup_codes" USING btree ("account_id");--> statement-breakpoint
CREATE INDEX "admin_sessions_account" ON "identity"."admin_sessions" USING btree ("account_id");--> statement-breakpoint
CREATE INDEX "admin_setup_links_account" ON "identity"."admin_setup_links" USING btree ("account_id");