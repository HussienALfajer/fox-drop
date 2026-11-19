CREATE TABLE "captains"."application_document_requests" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"application_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"reason" text NOT NULL,
	"requested_by" uuid NOT NULL,
	"requested_at" timestamp with time zone NOT NULL,
	"fulfilled_at" timestamp with time zone,
	CONSTRAINT "application_document_requests_kind_values" CHECK ("captains"."application_document_requests"."kind" IN ('national_id', 'personal_photo', 'civil_registry', 'criminal_record', 'vehicle_papers', 'driving_licence'))
);
--> statement-breakpoint
CREATE TABLE "captains"."application_events" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"application_id" uuid NOT NULL,
	"at" timestamp with time zone NOT NULL,
	"actor_id" uuid,
	"kind" text NOT NULL,
	"stage" text NOT NULL,
	"document_kind" text,
	"document_status" text,
	"note" text,
	"idempotency_key" text,
	CONSTRAINT "application_events_kind_values" CHECK ("captains"."application_events"."kind" IN ('submitted', 'stage', 'note', 'document_review', 'document_request', 'document_upload', 'interview')),
	CONSTRAINT "application_events_stage_values" CHECK ("captains"."application_events"."stage" IN ('draft', 'new', 'under_review', 'interview', 'awaiting_kit', 'active', 'waitlist', 'rejected'))
);
--> statement-breakpoint
ALTER TABLE "notifications"."alerts" DROP CONSTRAINT "alerts_subject_type";--> statement-breakpoint
ALTER TABLE "notifications"."push_devices" DROP CONSTRAINT "push_devices_captain";--> statement-breakpoint
ALTER TABLE "notifications"."push_messages" DROP CONSTRAINT "push_messages_recipient";--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "interview_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "interview_place" text;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "interview_latitude" double precision;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "interview_longitude" double precision;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "rejected_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD COLUMN "rejection_reason" text;--> statement-breakpoint
ALTER TABLE "captains"."application_document_requests" ADD CONSTRAINT "application_document_requests_application_id_applications_id_fk" FOREIGN KEY ("application_id") REFERENCES "captains"."applications"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "captains"."application_events" ADD CONSTRAINT "application_events_application_id_applications_id_fk" FOREIGN KEY ("application_id") REFERENCES "captains"."applications"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "application_document_requests_open" ON "captains"."application_document_requests" USING btree ("application_id","kind") WHERE "captains"."application_document_requests"."fulfilled_at" IS NULL;--> statement-breakpoint
CREATE UNIQUE INDEX "application_events_key" ON "captains"."application_events" USING btree ("actor_id","idempotency_key") WHERE "captains"."application_events"."idempotency_key" IS NOT NULL;--> statement-breakpoint
CREATE INDEX "application_events_application" ON "captains"."application_events" USING btree ("application_id","at");--> statement-breakpoint
CREATE INDEX "application_documents_number" ON "captains"."application_documents" USING btree ("number") WHERE "captains"."application_documents"."number" IS NOT NULL;--> statement-breakpoint
CREATE INDEX "applications_stage" ON "captains"."applications" USING btree ("city_id","stage","submitted_at");--> statement-breakpoint
CREATE INDEX "applications_plate_key" ON "captains"."applications" USING btree (lower(replace("plate", ' ', ''))) WHERE "captains"."applications"."plate" IS NOT NULL;--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_interview" CHECK (("captains"."applications"."interview_at" IS NULL) = ("captains"."applications"."interview_place" IS NULL) AND ("captains"."applications"."interview_at" IS NULL) = ("captains"."applications"."interview_latitude" IS NULL) AND ("captains"."applications"."interview_latitude" IS NULL) = ("captains"."applications"."interview_longitude" IS NULL));--> statement-breakpoint
ALTER TABLE "captains"."applications" ADD CONSTRAINT "applications_rejected" CHECK (("captains"."applications"."stage" = 'rejected') = ("captains"."applications"."rejected_at" IS NOT NULL) AND ("captains"."applications"."rejected_at" IS NULL) = ("captains"."applications"."rejection_reason" IS NULL));--> statement-breakpoint
ALTER TABLE "notifications"."alerts" ADD CONSTRAINT "alerts_subject_type" CHECK ("notifications"."alerts"."subject_type" IN ('order', 'captain', 'otp_pool', 'otp_number', 'restaurant', 'currency', 'compensation', 'ticket', 'price_change', 'captain_application')) NOT VALID;--> statement-breakpoint
ALTER TABLE "notifications"."alerts" VALIDATE CONSTRAINT "alerts_subject_type";--> statement-breakpoint
ALTER TABLE "notifications"."push_devices" ADD CONSTRAINT "push_devices_captain" CHECK ("notifications"."push_devices"."captain_id" IS NULL OR "notifications"."push_devices"."party" = 'captain') NOT VALID;--> statement-breakpoint
ALTER TABLE "notifications"."push_devices" VALIDATE CONSTRAINT "push_devices_captain";--> statement-breakpoint
ALTER TABLE "notifications"."push_messages" ADD CONSTRAINT "push_messages_recipient" CHECK (("notifications"."push_messages"."party" <> 'customer' OR "notifications"."push_messages"."account_id" IS NOT NULL) AND ("notifications"."push_messages"."account_id" IS NULL OR "notifications"."push_messages"."party" = 'customer' OR ("notifications"."push_messages"."party" = 'merchant' AND "notifications"."push_messages"."owners_only") OR ("notifications"."push_messages"."party" = 'captain' AND "notifications"."push_messages"."captain_id" IS NULL)) AND ("notifications"."push_messages"."party" = 'merchant') = ("notifications"."push_messages"."restaurant_id" IS NOT NULL) AND ("notifications"."push_messages"."captain_id" IS NULL OR "notifications"."push_messages"."party" = 'captain') AND ("notifications"."push_messages"."party" <> 'captain' OR ("notifications"."push_messages"."captain_id" IS NOT NULL) <> ("notifications"."push_messages"."account_id" IS NOT NULL)) AND (NOT "notifications"."push_messages"."owners_only" OR "notifications"."push_messages"."party" = 'merchant')) NOT VALID;--> statement-breakpoint
ALTER TABLE "notifications"."push_messages" VALIDATE CONSTRAINT "push_messages_recipient";--> statement-breakpoint
-- The history and the notes are never changed (slice 2.34b).
REVOKE UPDATE ON "captains"."application_events" FROM fox_drop_app;
