CREATE TABLE "ordering"."order_contacts" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"order_id" uuid NOT NULL,
	"order_placed_at" timestamp with time zone NOT NULL,
	"city_id" uuid NOT NULL,
	"actor_type" text NOT NULL,
	"actor_id" uuid NOT NULL,
	"actor_device" text,
	"channel" text NOT NULL,
	"status" text NOT NULL,
	"version" integer NOT NULL,
	"at" timestamp with time zone NOT NULL,
	CONSTRAINT "order_contacts_values" CHECK ("ordering"."order_contacts"."actor_type" IN ('restaurant', 'customer', 'captain')
        AND "ordering"."order_contacts"."channel" IN ('call', 'whatsapp')
        AND ("ordering"."order_contacts"."channel" = 'call' OR "ordering"."order_contacts"."actor_type" = 'captain')
        AND ("ordering"."order_contacts"."actor_device" IS NULL OR "ordering"."order_contacts"."actor_type" = 'restaurant'))
);
--> statement-breakpoint
ALTER TABLE "ordering"."order_contacts" ADD CONSTRAINT "order_contacts_order_id_order_placed_at_orders_id_placed_at_fk" FOREIGN KEY ("order_id","order_placed_at") REFERENCES "ordering"."orders"("id","placed_at") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "order_contacts_order" ON "ordering"."order_contacts" USING btree ("order_id","order_placed_at","at");--> statement-breakpoint
REVOKE UPDATE ON "ordering"."order_contacts" FROM fox_drop_app;