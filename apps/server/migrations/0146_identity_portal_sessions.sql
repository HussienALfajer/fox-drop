CREATE TABLE "identity"."merchant_portal_sessions" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"browser_id" uuid NOT NULL,
	"token_hash" text NOT NULL,
	"user_agent" text,
	"ip_address" "inet",
	"signed_in_at" timestamp with time zone NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"ended_at" timestamp with time zone,
	"end_reason" text,
	CONSTRAINT "merchant_portal_sessions_end_reason_values" CHECK ("identity"."merchant_portal_sessions"."end_reason" IN ('sign_out', 'account_removed')),
	CONSTRAINT "merchant_portal_sessions_ended" CHECK (("identity"."merchant_portal_sessions"."ended_at" IS NULL) = ("identity"."merchant_portal_sessions"."end_reason" IS NULL)),
	CONSTRAINT "merchant_portal_sessions_expiry" CHECK ("identity"."merchant_portal_sessions"."expires_at" > "identity"."merchant_portal_sessions"."signed_in_at")
);
--> statement-breakpoint
ALTER TABLE "identity"."merchant_portal_sessions" ADD CONSTRAINT "merchant_portal_sessions_account_id_merchant_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "identity"."merchant_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "merchant_portal_sessions_token" ON "identity"."merchant_portal_sessions" USING btree ("token_hash");--> statement-breakpoint
CREATE INDEX "merchant_portal_sessions_open_account" ON "identity"."merchant_portal_sessions" USING btree ("account_id") WHERE "identity"."merchant_portal_sessions"."ended_at" IS NULL;