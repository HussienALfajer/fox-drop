ALTER TABLE "captains"."application_document_requests" DROP CONSTRAINT "application_document_requests_kind_values";--> statement-breakpoint
ALTER TABLE "captains"."application_documents" DROP CONSTRAINT "application_documents_kind_values";--> statement-breakpoint
ALTER TABLE "captains"."application_documents" DROP CONSTRAINT "application_documents_files";--> statement-breakpoint
ALTER TABLE "captains"."application_events" DROP CONSTRAINT "application_events_kind_values";--> statement-breakpoint
ALTER TABLE "captains"."application_events" DROP CONSTRAINT "application_events_document_kind_values";--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "kit_items" jsonb;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "kit_issued_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "custody_limit" bigint;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "custody_limit_currency" text;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "contract_signed_on" date;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "contract_starts_on" date;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "probation_days" integer;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "commitment_months" integer;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "probation_ends_on" date;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "deposit_amount" bigint;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "deposit_instalment" bigint;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "deposit_currency" text;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "captain_id" uuid;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "activated_at" timestamp with time zone;--> statement-breakpoint
CREATE UNIQUE INDEX "applications_captain" ON "captains"."applications" USING btree ("captain_id");--> statement-breakpoint
ALTER TABLE "captains"."application_document_requests" ADD CONSTRAINT "application_document_requests_kind_values" CHECK ("captains"."application_document_requests"."kind" IN ('national_id', 'personal_photo', 'civil_registry', 'criminal_record', 'vehicle_papers', 'driving_licence', 'signed_contract'));--> statement-breakpoint
ALTER TABLE "captains"."application_documents" ADD CONSTRAINT "application_documents_kind_values" CHECK ("captains"."application_documents"."kind" IN ('national_id', 'personal_photo', 'civil_registry', 'criminal_record', 'vehicle_papers', 'driving_licence', 'signed_contract'));--> statement-breakpoint
ALTER TABLE "captains"."application_documents" ADD CONSTRAINT "application_documents_files" CHECK (cardinality("captains"."application_documents"."file_keys") BETWEEN 1 AND (CASE WHEN "captains"."application_documents"."kind" = 'signed_contract' THEN 6 ELSE 2 END));--> statement-breakpoint
ALTER TABLE "captains"."application_events" ADD CONSTRAINT "application_events_kind_values" CHECK ("captains"."application_events"."kind" IN ('submitted', 'stage', 'note', 'document_review', 'document_request', 'document_upload', 'interview', 'kit', 'cash_limit', 'contract', 'deposit'));--> statement-breakpoint
ALTER TABLE "captains"."application_events" ADD CONSTRAINT "application_events_document_kind_values" CHECK ("captains"."application_events"."document_kind" IN ('national_id', 'personal_photo', 'civil_registry', 'criminal_record', 'vehicle_papers', 'driving_licence', 'signed_contract'));--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_kit" CHECK (("captains"."applications"."kit_items" IS NULL) = ("captains"."applications"."kit_issued_at" IS NULL));--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_custody_limit" CHECK (("captains"."applications"."custody_limit" IS NULL) = ("captains"."applications"."custody_limit_currency" IS NULL) AND ("captains"."applications"."custody_limit" IS NULL OR "captains"."applications"."custody_limit" > 0));--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_contract" CHECK (("captains"."applications"."contract_signed_on" IS NULL) = ("captains"."applications"."contract_starts_on" IS NULL) AND ("captains"."applications"."contract_signed_on" IS NULL) = ("captains"."applications"."probation_days" IS NULL) AND ("captains"."applications"."contract_signed_on" IS NULL) = ("captains"."applications"."commitment_months" IS NULL) AND ("captains"."applications"."contract_signed_on" IS NULL) = ("captains"."applications"."probation_ends_on" IS NULL) AND ("captains"."applications"."contract_starts_on" IS NULL OR "captains"."applications"."contract_starts_on" >= "captains"."applications"."contract_signed_on"));--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_deposit" CHECK (("captains"."applications"."deposit_amount" IS NULL) = ("captains"."applications"."deposit_currency" IS NULL) AND ("captains"."applications"."deposit_amount" IS NULL OR "captains"."applications"."deposit_amount" >= 0) AND ("captains"."applications"."deposit_instalment" IS NULL OR ("captains"."applications"."deposit_amount" IS NOT NULL AND "captains"."applications"."deposit_instalment" > 0)));--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_activated" CHECK (("captains"."applications"."stage" = 'active') = ("captains"."applications"."activated_at" IS NOT NULL) AND ("captains"."applications"."activated_at" IS NULL) = ("captains"."applications"."captain_id" IS NULL));