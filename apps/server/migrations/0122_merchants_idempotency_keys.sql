CREATE TABLE "merchants"."idempotency_keys" (
	"account_id" uuid NOT NULL,
	"key" text NOT NULL,
	"request_hash" text NOT NULL,
	"result" jsonb NOT NULL,
	"created_at" timestamp with time zone NOT NULL,
	CONSTRAINT "idempotency_keys_account_id_key_pk" PRIMARY KEY("account_id","key")
);
