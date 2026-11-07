CREATE SCHEMA "content";
--> statement-breakpoint
GRANT USAGE ON SCHEMA "content" TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "content" GRANT SELECT, INSERT, UPDATE ON TABLES TO fox_drop_app;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA "content" GRANT USAGE, SELECT ON SEQUENCES TO fox_drop_app;
--> statement-breakpoint
CREATE TABLE "content"."reasons" (
	"id" uuid PRIMARY KEY DEFAULT uuidv7() NOT NULL,
	"list" text NOT NULL,
	"code" text NOT NULL,
	"label" text NOT NULL,
	"customer_text" text,
	"note" text DEFAULT 'none' NOT NULL,
	"fixed" boolean DEFAULT false NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"position" integer NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "reasons_list_code" UNIQUE("list","code"),
	CONSTRAINT "reasons_code" CHECK ("content"."reasons"."code" ~ '^[a-z0-9_]{1,40}$'),
	CONSTRAINT "reasons_label" CHECK (char_length("content"."reasons"."label") BETWEEN 1 AND 100),
	CONSTRAINT "reasons_customer_text" CHECK ("content"."reasons"."customer_text" IS NULL OR char_length("content"."reasons"."customer_text") BETWEEN 1 AND 300),
	CONSTRAINT "reasons_note" CHECK ("content"."reasons"."note" IN ('none', 'optional', 'required')),
	CONSTRAINT "reasons_fixed_active" CHECK (NOT "content"."reasons"."fixed" OR "content"."reasons"."active")
);
--> statement-breakpoint
CREATE TABLE "content"."texts" (
	"key" text PRIMARY KEY NOT NULL,
	"value" jsonb NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "ordering"."collections" DROP CONSTRAINT "collections_shortfall";--> statement-breakpoint
ALTER TABLE "ordering"."orders" DROP CONSTRAINT "orders_away_reason";--> statement-breakpoint
ALTER TABLE "ordering"."collections" ADD COLUMN "shortfall_reason_label" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "away_reason_label" text;--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD COLUMN "cancel_customer_text" text;--> statement-breakpoint
ALTER TABLE "ordering"."collections" ADD CONSTRAINT "collections_shortfall" CHECK (("shortfall" > 0) = ("shortfall_reason" IS NOT NULL) AND ("shortfall_reason" IS NOT NULL OR ("shortfall_reason_label" IS NULL AND "shortfall_note" IS NULL)) AND char_length("shortfall_note") BETWEEN 1 AND 200);--> statement-breakpoint
ALTER TABLE "ordering"."orders" ADD CONSTRAINT "orders_away_reason" CHECK (("away_reason" IS NOT NULL OR ("away_reason_label" IS NULL AND "away_note" IS NULL)) AND char_length("away_note") BETWEEN 1 AND 200);
--> statement-breakpoint
-- AP Appendix B and CU Appendix C: the default lists, editable in Content.
INSERT INTO "content"."reasons" ("list", "code", "label", "customer_text", "note", "fixed", "position") VALUES
	('merchant_rejection', 'item_unavailable', 'صنف غير متوفر', 'بعض الأصناف غير متوفرة: {الأصناف}', 'none', true, 1),
	('merchant_rejection', 'restaurant_closed', 'المطعم مغلق', 'المطعم أغلق ولا يستقبل طلبات الآن', 'none', true, 2),
	('merchant_rejection', 'too_busy', 'ضغط طلبات', 'المطعم مشغول جداً الآن', 'none', true, 3),
	('merchant_problem', 'captain_late', 'الكابتن تأخر', NULL, 'none', false, 1),
	('merchant_problem', 'captain_conduct', 'سلوك الكابتن', NULL, 'none', false, 2),
	('merchant_problem', 'pickup_amount', 'مشكلة في مبلغ الاستلام', NULL, 'none', true, 3),
	('merchant_problem', 'order_problem', 'مشكلة في الطلب', NULL, 'none', false, 4),
	('merchant_problem', 'other', 'أخرى', NULL, 'none', false, 5),
	('item_unavailable_note', 'similar_alternative', 'يوجد بديل مشابه', NULL, 'none', false, 1),
	('item_unavailable_note', 'insufficient_quantity', 'الكمية غير كافية', NULL, 'none', false, 2),
	('merchant_ticket_type', 'order_problem', 'مشكلة في طلب', NULL, 'none', false, 1),
	('merchant_ticket_type', 'finance_inquiry', 'استفسار مالي', NULL, 'none', false, 2),
	('merchant_ticket_type', 'data_change', 'طلب تعديل بيانات', NULL, 'none', false, 3),
	('merchant_ticket_type', 'app_problem', 'مشكلة في التطبيق', NULL, 'none', false, 4),
	('merchant_ticket_type', 'other', 'أخرى', NULL, 'none', false, 5),
	('captain_cannot_complete', 'vehicle_breakdown', 'عطل في المركبة', NULL, 'none', false, 1),
	('captain_cannot_complete', 'accident', 'حادث', NULL, 'none', false, 2),
	('captain_cannot_complete', 'emergency', 'ظرف طارئ', NULL, 'none', false, 3),
	('captain_cannot_complete', 'no_pickup_cash', 'لا أملك المبلغ المطلوب للمطعم', NULL, 'none', false, 4),
	('captain_cannot_complete', 'other', 'أخرى', NULL, 'required', false, 5),
	('captain_away', 'customer_requested_other_place', 'الزبون طلب مكاناً آخر', NULL, 'none', false, 1),
	('captain_away', 'pin_inaccurate', 'موقع الزبون على الخريطة غير دقيق', NULL, 'none', false, 2),
	('captain_away', 'other', 'أخرى', NULL, 'required', false, 3),
	('shortfall', 'customer_short', 'الزبون لا يملك المبلغ كاملاً', NULL, 'none', false, 1),
	('shortfall', 'counting_error', 'خطأ في العد', NULL, 'none', false, 2),
	('shortfall', 'other', 'أخرى', NULL, 'required', false, 3),
	('food_after_failed', 'kept_by_captain', 'يبقى مع الكابتن', NULL, 'none', true, 1),
	('food_after_failed', 'returned_to_restaurant', 'أُعيد إلى المطعم', NULL, 'none', true, 2),
	('food_after_failed', 'destroyed', 'أُتلف', NULL, 'none', true, 3),
	('captain_ticket_type', 'order_problem', 'مشكلة في طلب', NULL, 'none', false, 1),
	('captain_ticket_type', 'custody_or_earnings', 'مشكلة في العهدة أو الأرباح', NULL, 'none', false, 2),
	('captain_ticket_type', 'data_change', 'طلب تعديل بيانات', NULL, 'none', false, 3),
	('captain_ticket_type', 'end_contract', 'إنهاء التعاقد', NULL, 'none', false, 4),
	('captain_ticket_type', 'equipment_swap', 'تبديل العدة', NULL, 'none', false, 5),
	('captain_ticket_type', 'app_problem', 'مشكلة في التطبيق', NULL, 'none', false, 6),
	('captain_ticket_type', 'other', 'أخرى', NULL, 'none', false, 7),
	('captain_problem', 'restaurant_late', 'المطعم متأخر', NULL, 'none', false, 1),
	('captain_problem', 'missing_item', 'صنف ناقص', NULL, 'none', false, 2),
	('captain_problem', 'pickup_amount', 'مشكلة في مبلغ الاستلام', NULL, 'none', true, 3),
	('captain_problem', 'wrong_address', 'العنوان خاطئ', NULL, 'none', false, 4),
	('captain_problem', 'customer_not_answering', 'الزبون لا يرد', NULL, 'none', false, 5),
	('captain_problem', 'accident_or_emergency', 'حادث أو طارئ', NULL, 'none', false, 6),
	('captain_problem', 'other', 'أخرى', NULL, 'none', false, 7),
	('customer_cancel', 'changed_mind', 'غيّرت رأيي', NULL, 'none', false, 1),
	('customer_cancel', 'ordered_by_mistake', 'طلبت بالخطأ', NULL, 'none', false, 2),
	('customer_cancel', 'wrong_address', 'العنوان خاطئ', NULL, 'none', false, 3),
	('customer_cancel', 'other', 'سبب آخر', NULL, 'optional', false, 4),
	('customer_problem', 'missing_item', 'صنف ناقص', NULL, 'optional', false, 1),
	('customer_problem', 'wrong_item', 'صنف خطأ', NULL, 'optional', false, 2),
	('customer_problem', 'cold_food', 'الطعام بارد', NULL, 'optional', false, 3),
	('customer_problem', 'damaged_order', 'الطلب تالف', NULL, 'optional', false, 4),
	('customer_problem', 'late', 'تأخير', NULL, 'optional', false, 5),
	('customer_problem', 'captain_conduct', 'سلوك الكابتن', NULL, 'optional', false, 6),
	('customer_problem', 'amount_or_change', 'مشكلة في المبلغ أو الباقي', NULL, 'optional', false, 7),
	('customer_problem', 'other', 'أخرى', NULL, 'required', false, 8),
	('order_note', 'call_on_arrival', 'اتصل بي عند الوصول', NULL, 'none', false, 1),
	('order_note', 'do_not_knock', 'لا تطرق الباب', NULL, 'none', false, 2),
	('order_note', 'send_cutlery', 'أرسلوا أدوات طعام', NULL, 'none', false, 3),
	('order_note', 'no_cutlery', 'لا أحتاج أدوات طعام', NULL, 'none', false, 4),
	('restaurant_rating_low', 'cold_food', 'الطعام بارد', NULL, 'none', false, 1),
	('restaurant_rating_low', 'bad_taste', 'الطعم غير جيد', NULL, 'none', false, 2),
	('restaurant_rating_low', 'missing_or_wrong_item', 'صنف ناقص أو خطأ', NULL, 'none', false, 3),
	('restaurant_rating_low', 'small_quantity', 'الكمية قليلة', NULL, 'none', false, 4),
	('restaurant_rating_low', 'bad_packaging', 'التغليف سيئ', NULL, 'none', false, 5),
	('restaurant_rating_mid', 'could_be_better', 'جيد لكن يمكن أفضل', NULL, 'none', false, 1),
	('restaurant_rating_mid', 'small_quantity', 'الكمية قليلة', NULL, 'none', false, 2),
	('restaurant_rating_mid', 'packaging_needs_work', 'التغليف يحتاج تحسيناً', NULL, 'none', false, 3),
	('restaurant_rating_high', 'great_taste', 'طعم رائع', NULL, 'none', false, 1),
	('restaurant_rating_high', 'hot_and_fresh', 'حار وطازج', NULL, 'none', false, 2),
	('restaurant_rating_high', 'good_quantity', 'كمية جيدة', NULL, 'none', false, 3),
	('restaurant_rating_high', 'great_packaging', 'تغليف ممتاز', NULL, 'none', false, 4),
	('captain_rating_low', 'late', 'تأخر', NULL, 'none', false, 1),
	('captain_rating_low', 'improper_conduct', 'سلوك غير لائق', NULL, 'none', false, 2),
	('captain_rating_low', 'no_call_on_arrival', 'لم يتصل عند الوصول', NULL, 'none', false, 3),
	('captain_rating_low', 'arrived_damaged', 'الطلب وصل تالفاً', NULL, 'none', false, 4),
	('captain_rating_mid', 'slightly_late', 'تأخر قليلاً', NULL, 'none', false, 1),
	('captain_rating_mid', 'needs_more_kindness', 'يحتاج لطفاً أكثر', NULL, 'none', false, 2),
	('captain_rating_high', 'kind', 'لطيف', NULL, 'none', false, 1),
	('captain_rating_high', 'fast', 'سريع', NULL, 'none', false, 2),
	('captain_rating_high', 'kept_order_safe', 'حافظ على الطلب', NULL, 'none', false, 3),
	('captain_rating_high', 'followed_instructions', 'ملتزم بالتعليمات', NULL, 'none', false, 4),
	('ops_cancel', 'customer_request', 'طلب الزبون', 'أُلغي بناءً على طلبك', 'none', false, 1),
	('ops_cancel', 'restaurant_no_response', 'المطعم لم يستجب', 'لم يرد المطعم على طلبك', 'none', false, 2),
	('ops_cancel', 'restaurant_closed', 'المطعم أغلق', 'المطعم أغلق ولا يستقبل طلبات الآن', 'none', false, 3),
	('ops_cancel', 'item_sold_out', 'صنف نفد', 'أحد الأصناف نفد من المطعم', 'none', false, 4),
	('ops_cancel', 'no_captain', 'لا يوجد كابتن', 'لم نجد كابتناً متاحاً لطلبك', 'none', false, 5),
	('ops_cancel', 'outside_zone', 'العنوان خارج المنطقة', 'العنوان خارج منطقة التوصيل', 'none', false, 6),
	('ops_cancel', 'emergency', 'ظرف طارئ', 'ظرف طارئ منعنا من إكمال طلبك', 'none', false, 7),
	('ops_cancel', 'other', 'سبب آخر', 'نعتذر، أُلغي طلبك', 'none', false, 8),
	('reassignment', 'vehicle_breakdown', 'عطل في المركبة', NULL, 'none', false, 1),
	('reassignment', 'accident', 'حادث', NULL, 'none', false, 2),
	('reassignment', 'captain_request', 'طلب الكابتن', NULL, 'none', false, 3),
	('reassignment', 'captain_late', 'تأخر الكابتن', NULL, 'none', false, 4),
	('reassignment', 'connection_lost', 'انقطاع الاتصال', NULL, 'none', false, 5),
	('reassignment', 'other', 'سبب آخر', NULL, 'none', false, 6),
	('captain_suspension', 'conduct_violation', 'مخالفة سلوك', NULL, 'none', false, 1),
	('captain_suspension', 'repeated_complaints', 'شكاوى متكررة', NULL, 'none', false, 2),
	('captain_suspension', 'low_acceptance', 'نسبة قبول منخفضة', NULL, 'none', false, 3),
	('captain_suspension', 'expired_document', 'مستند منتهي', NULL, 'none', false, 4),
	('captain_suspension', 'captain_request', 'طلب الكابتن', NULL, 'none', false, 5),
	('captain_suspension', 'other', 'أخرى', NULL, 'none', false, 6),
	('customer_block', 'fake_order', 'طلب وهمي', 'طلب لم يُستلم', 'none', false, 1),
	('customer_block', 'abuse', 'إساءة', 'مخالفة شروط الاستخدام', 'none', false, 2),
	('customer_block', 'code_fraud', 'احتيال على الأكواد', 'استخدام غير مسموح لأكواد الخصم', 'none', false, 3),
	('customer_block', 'other', 'أخرى', 'مخالفة شروط الاستخدام', 'none', false, 4),
	('emergency_stop', 'weather', 'أحوال جوية', NULL, 'none', false, 1),
	('emergency_stop', 'power_or_internet', 'انقطاع كهرباء أو إنترنت', NULL, 'none', false, 2),
	('emergency_stop', 'security', 'ظرف أمني', NULL, 'none', false, 3),
	('emergency_stop', 'technical', 'عطل تقني', NULL, 'none', false, 4),
	('emergency_stop', 'other', 'أخرى', NULL, 'none', false, 5),
	('failed_outcome', 'failed_other', 'تعذّر التسليم', 'تعذّر الوصول إليك أو إلى العنوان', 'none', true, 1),
	('failed_outcome', 'wrong_refused', 'خطأ ورفضه الزبون', 'رفضت الطلب لأنه غير صحيح', 'none', true, 2),
	('failed_outcome', 'damaged', 'تالف', 'وصل الطلب تالفاً', 'none', true, 3),
	('failed_outcome', 'fake', 'وهمي', 'لم يُستلم الطلب', 'none', true, 4),
	('system_cancellation', 'merchant_auto_cancel', 'المطعم لم يستجب', 'لم يرد المطعم على طلبك', 'none', true, 1);
--> statement-breakpoint
-- The orders recorded before Content keep the label their code had.
UPDATE "ordering"."orders" SET "away_reason_label" = CASE "away_reason"
	WHEN 'customer_requested_other_place' THEN 'الزبون طلب مكاناً آخر'
	WHEN 'pin_inaccurate' THEN 'موقع الزبون على الخريطة غير دقيق'
	ELSE 'أخرى' END
WHERE "away_reason" IS NOT NULL;
--> statement-breakpoint
UPDATE "ordering"."collections" SET "shortfall_reason_label" = CASE "shortfall_reason"
	WHEN 'customer_short' THEN 'الزبون لا يملك المبلغ كاملاً'
	WHEN 'counting_error' THEN 'خطأ في العد'
	ELSE 'أخرى' END
WHERE "shortfall_reason" IS NOT NULL;
--> statement-breakpoint
UPDATE "ordering"."orders" SET "cancel_customer_text" = 'لم يرد المطعم على طلبك'
WHERE "cancel_reason" = 'merchant_auto_cancel';
--> statement-breakpoint
-- AP §9.13: drafts of the FAQs and the captain work rules (CA §11.4) for the
-- owner to edit (owner decision 2026-11-07).
INSERT INTO "content"."texts" ("key", "value") VALUES
	('faq.customer', '[{"question": "كيف أدفع ثمن طلبي؟", "answer": "تدفع نقداً للكابتن عند الباب، بالعملة التي اخترتها في «سأدفع بـ» أو بأي عملة يقبلها التطبيق للطلب."}, {"question": "متى يصل طلبي؟", "answer": "بعد أن يقبل المطعم طلبك يظهر لك وقت الوصول المتوقع، وتتابع طلبك خطوة بخطوة في صفحة الطلب."}, {"question": "ماذا أفعل إذا كان في طلبي مشكلة؟", "answer": "افتح الطلب واختر المشكلة، أو تواصل مع الدعم من «المساعدة»."}, {"question": "كيف أتواصل مع الدعم؟", "answer": "من «المساعدة» في «حسابي»: «واتساب الدعم» أو «اتصال بالدعم»."}]'::jsonb),
	('faq.captain', '[{"question": "متى أسلّم المبالغ التي قبضتها؟", "answer": "تسلّم ما معك من نقود كل يوم في مكتب FOX DROP، ولا تتجاوز حد العهدة."}, {"question": "متى أستلم أرباحي؟", "answer": "تُصرف أرباح الأسبوع كل يوم خميس."}, {"question": "ماذا أفعل إذا كان الطلب ناقصاً عند المطعم؟", "answer": "افحص الأصناف قبل الاستلام. إذا نقص شيء فلا تستلم الطلب وأبلغ من «مشكلة»."}, {"question": "ماذا أفعل إذا طلب الزبون مكاناً آخر؟", "answer": "سلّم الطلب واختر سبب التسليم بعيداً عن العنوان عندما يطلبه التطبيق."}]'::jsonb),
	('faq.merchant', '[{"question": "كيف أقبل طلباً؟", "answer": "اضغط «قبول» واختر وقت التحضير، ثم اضغط «الطلب جاهز» عندما ينتهي التحضير."}, {"question": "من يدفع لي ثمن الطلب؟", "answer": "يدفع لك الكابتن عند الاستلام المبلغ الظاهر في الطلب، وتؤكد الاستلام في التطبيق."}, {"question": "ماذا أفعل إذا كان مبلغ الاستلام غير صحيح؟", "answer": "اضغط «المبلغ غير صحيح» واكتب ما استلمته، وسيتابع الدعم المشكلة."}, {"question": "كيف أتواصل مع الدعم؟", "answer": "من «الدعم» في التطبيق: واتساب أو اتصال."}]'::jsonb),
	('captain_work_rules', '{"body": "قواعد العمل مع FOX DROP:\n- العمل حر: تختار ساعات عملك، ولا توجد ورديات إلزامية.\n- افحص أصناف الطلب عند المطعم قبل الاستلام؛ بعد الاستلام يصبح الطلب مسؤوليتك.\n- لا تطلب من الزبون أكثر من المبلغ الظاهر في التطبيق، ولا تطلب إكرامية أبداً.\n- احمل معك نقوداً تكفي لدفع ثمن الطلبات للمطاعم.\n- سلّم المبالغ كل يوم، وتُصرف الأرباح كل خميس، ولا تتجاوز حد العهدة.\n- حافظ على نسبة قبول جيدة وعلى السلوك الحسن؛ المخالفات تتدرج من التنبيه إلى الإيقاف.\n- اعتنِ بالتغليف: الساخن بعيداً عن البارد، والحقيبة مغلقة.\n- بيانات الزبون للتوصيل فقط، ولا تستخدمها لأي غرض آخر.\n- الخوذة إلزامية لسائقي الدراجات النارية."}'::jsonb);
