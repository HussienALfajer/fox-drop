CREATE TABLE "notifications"."push_messages" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	"source" text NOT NULL,
	"party" text NOT NULL,
	"account_id" uuid,
	"restaurant_id" uuid,
	"owners_only" boolean DEFAULT false NOT NULL,
	"captain_id" uuid,
	"template_key" text NOT NULL,
	"body" text NOT NULL,
	"level" text NOT NULL,
	"priority" text NOT NULL,
	"data" jsonb NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"attempts" integer DEFAULT 0 NOT NULL,
	"next_attempt_at" timestamp with time zone NOT NULL,
	"sent_at" timestamp with time zone,
	"devices" integer,
	"gave_up_at" timestamp with time zone,
	CONSTRAINT "push_messages_source_unique" UNIQUE("source"),
	CONSTRAINT "push_messages_party" CHECK ("notifications"."push_messages"."party" IN ('customer', 'merchant', 'captain')),
	CONSTRAINT "push_messages_recipient" CHECK (("notifications"."push_messages"."party" = 'customer') = ("notifications"."push_messages"."account_id" IS NOT NULL) AND ("notifications"."push_messages"."party" = 'merchant') = ("notifications"."push_messages"."restaurant_id" IS NOT NULL) AND ("notifications"."push_messages"."party" = 'captain') = ("notifications"."push_messages"."captain_id" IS NOT NULL) AND (NOT "notifications"."push_messages"."owners_only" OR "notifications"."push_messages"."party" = 'merchant')),
	CONSTRAINT "push_messages_priority" CHECK ("notifications"."push_messages"."priority" IN ('high', 'normal')),
	CONSTRAINT "push_messages_done" CHECK ("notifications"."push_messages"."sent_at" IS NULL OR "notifications"."push_messages"."gave_up_at" IS NULL)
);
--> statement-breakpoint
CREATE INDEX "push_messages_pending" ON "notifications"."push_messages" USING btree ("next_attempt_at") WHERE "notifications"."push_messages"."sent_at" IS NULL AND "notifications"."push_messages"."gave_up_at" IS NULL;--> statement-breakpoint
CREATE INDEX "push_messages_customer" ON "notifications"."push_messages" USING btree ("account_id","created_at" DESC NULLS LAST) WHERE "notifications"."push_messages"."party" = 'customer';