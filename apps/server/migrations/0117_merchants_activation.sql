ALTER TABLE "merchants"."restaurants" ADD COLUMN "menu_images_waived_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD COLUMN "menu_images_waived_by" uuid;--> statement-breakpoint
ALTER TABLE "merchants"."restaurants" ADD CONSTRAINT "restaurants_menu_images_waiver" CHECK (("merchants"."restaurants"."menu_images_waived_at" IS NULL) = ("merchants"."restaurants"."menu_images_waived_by" IS NULL));--> statement-breakpoint
-- AP §9.6.3 step 8, §6.3 (slice 2.30b): «OWN can waive the image requirement».
INSERT INTO "identity"."admin_permissions" ("code") VALUES ('restaurants.waive_menu_images');--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OWN', 'restaurants.waive_menu_images');
