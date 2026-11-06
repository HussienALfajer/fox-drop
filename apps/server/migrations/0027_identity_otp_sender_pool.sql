CREATE TABLE "identity"."otp_sender_daily_counts" (
	"number_id" uuid NOT NULL,
	"day" date NOT NULL,
	"sent" integer DEFAULT 0 NOT NULL,
	"failed" integer DEFAULT 0 NOT NULL,
	"delivered" integer DEFAULT 0 NOT NULL,
	"read" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "otp_sender_daily_counts_number_id_day_pk" PRIMARY KEY("number_id","day")
);
--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" DROP CONSTRAINT "otp_sender_numbers_status_values";--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" DROP CONSTRAINT "otp_sender_numbers_disconnected_at";--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD COLUMN "warmup_started_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD COLUMN "throttled_until" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD COLUMN "throttled_from" text;--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD COLUMN "disabled_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_daily_counts" ADD CONSTRAINT "otp_sender_daily_counts_number_id_otp_sender_numbers_id_fk" FOREIGN KEY ("number_id") REFERENCES "identity"."otp_sender_numbers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD CONSTRAINT "otp_sender_numbers_warmup" CHECK (("identity"."otp_sender_numbers"."status" <> 'warming' OR "identity"."otp_sender_numbers"."warmup_started_at" IS NOT NULL) AND ("identity"."otp_sender_numbers"."status" <> 'active' OR "identity"."otp_sender_numbers"."warmup_started_at" IS NULL));--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD CONSTRAINT "otp_sender_numbers_throttled" CHECK (("identity"."otp_sender_numbers"."status" = 'throttled') = ("identity"."otp_sender_numbers"."throttled_until" IS NOT NULL) AND ("identity"."otp_sender_numbers"."status" = 'throttled') = ("identity"."otp_sender_numbers"."throttled_from" IS NOT NULL) AND "identity"."otp_sender_numbers"."throttled_from" IN ('warming', 'active'));--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD CONSTRAINT "otp_sender_numbers_status_values" CHECK ("identity"."otp_sender_numbers"."status" IN ('warming', 'active', 'standby', 'throttled', 'disconnected', 'banned'));--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_numbers" ADD CONSTRAINT "otp_sender_numbers_disconnected_at" CHECK (("identity"."otp_sender_numbers"."status" IN ('disconnected', 'banned')) = ("identity"."otp_sender_numbers"."disconnected_at" IS NOT NULL));--> statement-breakpoint
-- W1 kept a number paired again as a disconnected row; disable it, as a new pairing now does, so it raises no alert.
UPDATE "identity"."otp_sender_numbers" AS "earlier" SET "disabled_at" = now() WHERE "earlier"."status" = 'disconnected' AND EXISTS (SELECT 1 FROM "identity"."otp_sender_numbers" AS "later" WHERE "later"."phone_hash" = "earlier"."phone_hash" AND "later"."paired_at" > "earlier"."paired_at");
