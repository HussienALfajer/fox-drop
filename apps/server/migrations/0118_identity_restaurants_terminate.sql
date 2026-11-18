-- AP §9.6.5 «إنهاء» (slice 2.30c): ending a restaurant's contract, OWN alone.
INSERT INTO "identity"."admin_permissions" ("code") VALUES ('restaurants.terminate');--> statement-breakpoint
INSERT INTO "identity"."admin_role_permissions" ("role_code", "permission_code") VALUES
	('OWN', 'restaurants.terminate');
