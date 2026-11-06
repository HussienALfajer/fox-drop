CREATE TABLE "identity"."otp_sender_credentials" (
	"number_id" uuid NOT NULL,
	"key" text NOT NULL,
	"value_encrypted" text,
	"updated_at" timestamp with time zone NOT NULL,
	CONSTRAINT "otp_sender_credentials_number_id_key_pk" PRIMARY KEY("number_id","key")
);
--> statement-breakpoint
CREATE TABLE "identity"."otp_sender_numbers" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"phone_encrypted" text NOT NULL,
	"phone_hash" text NOT NULL,
	"status" text NOT NULL,
	"paired_at" timestamp with time zone NOT NULL,
	"disconnected_at" timestamp with time zone,
	CONSTRAINT "otp_sender_numbers_status_values" CHECK ("identity"."otp_sender_numbers"."status" IN ('active', 'disconnected')),
	CONSTRAINT "otp_sender_numbers_disconnected_at" CHECK (("identity"."otp_sender_numbers"."status" = 'disconnected') = ("identity"."otp_sender_numbers"."disconnected_at" IS NOT NULL))
);
--> statement-breakpoint
CREATE TABLE "identity"."otp_whatsapp_numbers" (
	"phone_hash" text PRIMARY KEY NOT NULL,
	"checked_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
ALTER TABLE "identity"."otp_sender_credentials" ADD CONSTRAINT "otp_sender_credentials_number_id_otp_sender_numbers_id_fk" FOREIGN KEY ("number_id") REFERENCES "identity"."otp_sender_numbers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "otp_sender_numbers_status_paired" ON "identity"."otp_sender_numbers" USING btree ("status","paired_at");