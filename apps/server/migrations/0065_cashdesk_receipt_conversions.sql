CREATE TABLE "cashdesk"."receipt_conversions" (
	"receipt_id" uuid NOT NULL,
	"from_currency" text NOT NULL,
	"from_amount" bigint NOT NULL,
	"to_currency" text NOT NULL,
	"to_amount" bigint NOT NULL,
	"journal_id" uuid NOT NULL,
	CONSTRAINT "receipt_conversions_receipt_id_from_currency_pk" PRIMARY KEY("receipt_id","from_currency"),
	CONSTRAINT "receipt_conversions_amounts" CHECK ("cashdesk"."receipt_conversions"."from_amount" > 0 AND "cashdesk"."receipt_conversions"."to_amount" > 0 AND "cashdesk"."receipt_conversions"."from_currency" <> "cashdesk"."receipt_conversions"."to_currency")
);
--> statement-breakpoint
ALTER TABLE "cashdesk"."receipt_conversions" ADD CONSTRAINT "receipt_conversions_receipt" FOREIGN KEY ("receipt_id") REFERENCES "cashdesk"."receipts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
-- AP §9.10.3: a receipt's conversion is never changed.
REVOKE UPDATE ON "cashdesk"."receipt_conversions" FROM fox_drop_app;
