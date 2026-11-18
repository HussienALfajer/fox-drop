CREATE TABLE "customers"."favourites" (
	"account_id" uuid NOT NULL,
	"restaurant_id" uuid NOT NULL,
	"added_at" timestamp with time zone NOT NULL,
	"removed_at" timestamp with time zone,
	CONSTRAINT "favourites_account_id_restaurant_id_pk" PRIMARY KEY("account_id","restaurant_id"),
	CONSTRAINT "favourites_removed_after_added" CHECK ("customers"."favourites"."removed_at" IS NULL OR "customers"."favourites"."removed_at" >= "customers"."favourites"."added_at")
);
