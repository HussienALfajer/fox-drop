CREATE TABLE "identity"."admin_account_roles" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"role_code" text NOT NULL,
	"granted_at" timestamp with time zone DEFAULT now() NOT NULL,
	"revoked_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "identity"."admin_permissions" (
	"code" text PRIMARY KEY NOT NULL
);
--> statement-breakpoint
CREATE TABLE "identity"."admin_role_permissions" (
	"role_code" text NOT NULL,
	"permission_code" text NOT NULL,
	CONSTRAINT "admin_role_permissions_role_code_permission_code_pk" PRIMARY KEY("role_code","permission_code")
);
--> statement-breakpoint
CREATE TABLE "identity"."admin_roles" (
	"code" text PRIMARY KEY NOT NULL
);
--> statement-breakpoint
ALTER TABLE "identity"."admin_accounts" DROP CONSTRAINT "admin_accounts_status_values";--> statement-breakpoint
ALTER TABLE "identity"."admin_sessions" DROP CONSTRAINT "admin_sessions_end_reason_values";--> statement-breakpoint
ALTER TABLE "identity"."admin_accounts" ALTER COLUMN "roles" SET DEFAULT '{}';--> statement-breakpoint
ALTER TABLE "identity"."admin_accounts" ADD COLUMN "name" text;--> statement-breakpoint
ALTER TABLE "identity"."admin_backup_codes" ADD COLUMN "revoked_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "identity"."admin_setup_links" ADD COLUMN "purpose" text DEFAULT 'setup' NOT NULL;--> statement-breakpoint
ALTER TABLE "identity"."admin_account_roles" ADD CONSTRAINT "admin_account_roles_account_id_admin_accounts_id_fk" FOREIGN KEY ("account_id") REFERENCES "identity"."admin_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."admin_account_roles" ADD CONSTRAINT "admin_account_roles_role_code_admin_roles_code_fk" FOREIGN KEY ("role_code") REFERENCES "identity"."admin_roles"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."admin_role_permissions" ADD CONSTRAINT "admin_role_permissions_role_code_admin_roles_code_fk" FOREIGN KEY ("role_code") REFERENCES "identity"."admin_roles"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."admin_role_permissions" ADD CONSTRAINT "admin_role_permissions_permission_code_admin_permissions_code_fk" FOREIGN KEY ("permission_code") REFERENCES "identity"."admin_permissions"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "admin_account_roles_held" ON "identity"."admin_account_roles" USING btree ("account_id","role_code") WHERE "identity"."admin_account_roles"."revoked_at" IS NULL;--> statement-breakpoint
ALTER TABLE "identity"."admin_accounts" ADD CONSTRAINT "admin_accounts_totp_reset_has_password" CHECK ("identity"."admin_accounts"."status" <> 'totp_reset' OR ("identity"."admin_accounts"."password_hash" IS NOT NULL AND "identity"."admin_accounts"."totp_secret_encrypted" IS NULL));--> statement-breakpoint
ALTER TABLE "identity"."admin_accounts" ADD CONSTRAINT "admin_accounts_status_values" CHECK ("identity"."admin_accounts"."status" IN ('pending', 'active', 'totp_reset', 'disabled'));--> statement-breakpoint
ALTER TABLE "identity"."admin_sessions" ADD CONSTRAINT "admin_sessions_end_reason_values" CHECK ("identity"."admin_sessions"."end_reason" IN ('sign_out', 'idle', 'max_lifetime', 'forced_sign_out', 'account_disabled', 'totp_reset'));--> statement-breakpoint
ALTER TABLE "identity"."admin_setup_links" ADD CONSTRAINT "admin_setup_links_purpose_values" CHECK ("identity"."admin_setup_links"."purpose" IN ('setup', 'totp_reset'));
--> statement-breakpoint
-- AP §6: roles and permissions change only through a migration.
REVOKE INSERT, UPDATE ON "identity"."admin_roles", "identity"."admin_permissions", "identity"."admin_role_permissions" FROM fox_drop_app;
--> statement-breakpoint
-- AP §6.1: the five fixed roles of V1.
INSERT INTO "identity"."admin_roles" ("code") VALUES ('OWN'), ('OPS'), ('SUP'), ('FIN'), ('DATA');
--> statement-breakpoint
-- AP §6.2–6.3.
INSERT INTO "identity"."admin_permissions" ("code") VALUES
	('dashboard.read'),
	('dashboard.manage'),
	('operations.read'),
	('operations.manage'),
	('operations.compensate'),
	('live_map.read'),
	('live_map.manage'),
	('order_history.read'),
	('order_history.manage'),
	('order_history.financial_correction'),
	('restaurants.read'),
	('restaurants.manage'),
	('restaurants.create'),
	('restaurants.menus'),
	('restaurants.statements'),
	('captains.read'),
	('captains.manage'),
	('captains.money'),
	('customers.read'),
	('customers.manage'),
	('customers.compensate'),
	('customers.dues'),
	('support.read'),
	('support.manage'),
	('finance.read'),
	('finance.manage'),
	('marketing.read'),
	('marketing.read_costs'),
	('marketing.manage'),
	('marketing.banners'),
	('zones.read'),
	('zones.manage'),
	('content.read'),
	('content.manage'),
	('content.faqs'),
	('content.categories'),
	('settings.read'),
	('settings.manage'),
	('admin_team.manage'),
	('audit_log.read'),
	('reports.operations'),
	('reports.support'),
	('reports.financial'),
	('reports.all'),
	('customers.reveal_phone'),
	('emergency_stop.toggle'),
	('dispatch.switch_mode'),
	('restaurants.commission'),
	('restaurants.activate'),
	('menus.edit_prices'),
	('captains.cash_limit'),
	('cash_desk.record'),
	('captains.hand_in_grace'),
	('captains.bulk_hand_in_grace'),
	('captains.off_cycle_payout'),
	('orders.change_outcome'),
	('orders.handover_after_pickup'),
	('orders.confirm_pickup'),
	('orders.act_for_captain'),
	('captains.release_device'),
	('captains.activate_early_exit'),
	('support.resolve_pickup_dispute'),
	('menus.review_change_requests'),
	('restaurants.owner_accounts'),
	('ledger.manual_adjustment'),
	('fx.edit_rates'),
	('compensation.approve_above_cap'),
	('pricing.edit_pay_tables'),
	('customers.close_account'),
	('customers.clear_strikes'),
	('customers.block'),
	('captains.suspend'),
	('captains.final_payout'),
	('exports.phone_numbers');
--> statement-breakpoint
-- OWN holds every permission (AP §6.1).
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code")
SELECT 'OWN', "code" FROM "identity"."admin_permissions";
--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OPS', 'dashboard.read'),
	('OPS', 'dashboard.manage'),
	('OPS', 'operations.read'),
	('OPS', 'operations.manage'),
	('OPS', 'operations.compensate'),
	('OPS', 'live_map.read'),
	('OPS', 'live_map.manage'),
	('OPS', 'order_history.read'),
	('OPS', 'order_history.manage'),
	('OPS', 'restaurants.read'),
	('OPS', 'restaurants.manage'),
	('OPS', 'restaurants.create'),
	('OPS', 'restaurants.menus'),
	('OPS', 'captains.read'),
	('OPS', 'captains.manage'),
	('OPS', 'customers.read'),
	('OPS', 'customers.manage'),
	('OPS', 'customers.compensate'),
	('OPS', 'support.read'),
	('OPS', 'support.manage'),
	('OPS', 'marketing.read'),
	('OPS', 'zones.read'),
	('OPS', 'content.read'),
	('OPS', 'reports.operations'),
	('OPS', 'customers.reveal_phone'),
	('OPS', 'emergency_stop.toggle'),
	('OPS', 'dispatch.switch_mode'),
	('OPS', 'restaurants.activate'),
	('OPS', 'menus.edit_prices'),
	('OPS', 'orders.handover_after_pickup'),
	('OPS', 'orders.confirm_pickup'),
	('OPS', 'orders.act_for_captain'),
	('OPS', 'captains.release_device'),
	('OPS', 'support.resolve_pickup_dispute'),
	('OPS', 'menus.review_change_requests'),
	('OPS', 'restaurants.owner_accounts'),
	('OPS', 'customers.close_account'),
	('OPS', 'customers.clear_strikes'),
	('OPS', 'customers.block'),
	('OPS', 'captains.suspend'),
	('OPS', 'exports.phone_numbers');
--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('SUP', 'dashboard.read'),
	('SUP', 'operations.read'),
	('SUP', 'operations.compensate'),
	('SUP', 'live_map.read'),
	('SUP', 'order_history.read'),
	('SUP', 'restaurants.read'),
	('SUP', 'captains.read'),
	('SUP', 'customers.read'),
	('SUP', 'customers.compensate'),
	('SUP', 'support.read'),
	('SUP', 'support.manage'),
	('SUP', 'content.faqs'),
	('SUP', 'reports.support'),
	('SUP', 'customers.reveal_phone'),
	('SUP', 'customers.close_account'),
	('SUP', 'customers.clear_strikes'),
	('SUP', 'exports.phone_numbers');
--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('FIN', 'dashboard.read'),
	('FIN', 'operations.read'),
	('FIN', 'order_history.read'),
	('FIN', 'order_history.financial_correction'),
	('FIN', 'restaurants.statements'),
	('FIN', 'captains.money'),
	('FIN', 'customers.read'),
	('FIN', 'customers.dues'),
	('FIN', 'support.read'),
	('FIN', 'support.resolve_pickup_dispute'),
	('FIN', 'finance.read'),
	('FIN', 'finance.manage'),
	('FIN', 'marketing.read_costs'),
	('FIN', 'zones.read'),
	('FIN', 'reports.financial'),
	('FIN', 'captains.cash_limit'),
	('FIN', 'cash_desk.record'),
	('FIN', 'captains.hand_in_grace'),
	('FIN', 'ledger.manual_adjustment'),
	('FIN', 'fx.edit_rates');
--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('DATA', 'restaurants.create'),
	('DATA', 'restaurants.menus'),
	('DATA', 'menus.edit_prices'),
	('DATA', 'marketing.banners'),
	('DATA', 'content.categories');
--> statement-breakpoint
-- The roles accounts held in the old column, as rows.
INSERT INTO "identity"."admin_account_roles" ("account_id", "role_code", "granted_at")
SELECT "id", unnest("roles"), "created_at" FROM "identity"."admin_accounts";
