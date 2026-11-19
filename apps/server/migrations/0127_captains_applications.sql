CREATE TABLE "captains"."application_documents" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"application_id" uuid NOT NULL,
	"kind" text NOT NULL,
	"file_keys" text[] NOT NULL,
	"number" text,
	"issue_date" date,
	"expires_on" date,
	"status" text NOT NULL,
	"reason" text,
	"reviewed_by" uuid,
	"reviewed_at" timestamp with time zone,
	"uploaded_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"replaced_at" timestamp with time zone,
	CONSTRAINT "application_documents_kind_values" CHECK ("captains"."application_documents"."kind" IN ('national_id', 'personal_photo', 'civil_registry', 'criminal_record', 'vehicle_papers', 'driving_licence')),
	CONSTRAINT "application_documents_status_values" CHECK ("captains"."application_documents"."status" IN ('pending', 'accepted', 'rejected')),
	CONSTRAINT "application_documents_files" CHECK (cardinality("captains"."application_documents"."file_keys") BETWEEN 1 AND 2)
);
--> statement-breakpoint
CREATE TABLE "captains"."applications" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"account_id" uuid NOT NULL,
	"city_id" uuid NOT NULL,
	"stage" text NOT NULL,
	"full_name" text NOT NULL,
	"birth_date" date NOT NULL,
	"zone_id" uuid NOT NULL,
	"vehicle" text,
	"plate" text,
	"submitted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone NOT NULL,
	CONSTRAINT "applications_stage_values" CHECK ("captains"."applications"."stage" IN ('draft', 'new', 'under_review', 'interview', 'awaiting_kit', 'active', 'waitlist', 'rejected')),
	CONSTRAINT "applications_vehicle_values" CHECK ("captains"."applications"."vehicle" IN ('walking', 'bicycle', 'motorbike', 'car')),
	CONSTRAINT "applications_plate" CHECK (("captains"."applications"."plate" IS NOT NULL) = ("captains"."applications"."vehicle" IN ('motorbike', 'car'))),
	CONSTRAINT "applications_submitted" CHECK (("captains"."applications"."stage" = 'draft') = ("captains"."applications"."submitted_at" IS NULL) AND ("captains"."applications"."stage" = 'draft' OR "captains"."applications"."vehicle" IS NOT NULL))
);
--> statement-breakpoint
ALTER TABLE "files"."uploads" DROP CONSTRAINT "uploads_purpose_values";--> statement-breakpoint
ALTER TABLE "captains"."application_documents" ADD CONSTRAINT "application_documents_application_id_applications_id_fk" FOREIGN KEY ("application_id") REFERENCES "captains"."applications"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "application_documents_in_force" ON "captains"."application_documents" USING btree ("application_id","kind") WHERE "captains"."application_documents"."replaced_at" IS NULL;--> statement-breakpoint
CREATE INDEX "application_documents_application" ON "captains"."application_documents" USING btree ("application_id","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "applications_open_account" ON "captains"."applications" USING btree ("account_id") WHERE "captains"."applications"."stage" <> 'rejected';--> statement-breakpoint
ALTER TABLE "files"."uploads" ADD CONSTRAINT "uploads_purpose_values" CHECK ("files"."uploads"."purpose" IN ('restaurant_logo', 'restaurant_cover', 'item_photo', 'report_photo', 'category_image', 'banner_image', 'restaurant_contract', 'restaurant_licence', 'menu_import', 'captain_document')) NOT VALID;--> statement-breakpoint
ALTER TABLE "files"."uploads" VALIDATE CONSTRAINT "uploads_purpose_values";