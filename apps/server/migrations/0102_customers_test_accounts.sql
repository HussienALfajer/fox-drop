CREATE TABLE "customers"."test_account_flags" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"customer_account_id" uuid NOT NULL,
	"flagged" boolean NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"by" uuid NOT NULL
);
--> statement-breakpoint
CREATE INDEX "test_account_flags_account_at" ON "customers"."test_account_flags" USING btree ("customer_account_id","at");--> statement-breakpoint
REVOKE UPDATE ON "customers"."test_account_flags" FROM fox_drop_app;--> statement-breakpoint
-- AP §9.8, §6.3 (slice 2.25b): OWN flags an admin test account.
INSERT INTO "identity"."admin_permissions" ("code") VALUES ('customers.test_account');--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OWN', 'customers.test_account');
