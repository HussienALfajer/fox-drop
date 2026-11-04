# 8. Finding food

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

## 8.1 Home

- **Sections** come from the panel in its order (AP §9.11.3):
  - «البانرات» (banners)
  - «التصنيفات» (categories)
  - «الأقرب إليك» (nearest to you)
  - «الأكثر طلباً» (most ordered)
  - «جديد على FOX DROP» (new on FOX DROP)
  - «العروض» (offers): restaurants with active visible codes
  - custom sections
- **Restaurants:** only those that deliver to the selected location appear (§8.2).
- **Banners:** a tap opens the banner's target: a restaurant, a category, a list of restaurants, or a code (AP §9.11.2). A code target opens «أكوادي» with that code shown.
- Pull to refresh.

## 8.2 Restaurant cards and lists

- **Which restaurants appear:** `active` and `visible` restaurants (AP §9.6.1) whose coverage includes the selected point (RA R13).
  - Test-mode restaurants appear only to admin test accounts, with the badge «تجريبي» (AP §9.8).
  - Suspended restaurants never appear.
- **A card shows:**
  - cover, logo and name
  - categories
  - the rating, or «جديد» (Q16)
  - the delivery estimate as a range (§8.4)
  - the delivery fee for the selected point, or «توصيل مجاني»
  - a state badge when it is not open: «مشغول», «متوقف مؤقتاً», or «مغلق — يفتح {اليوم} {الساعة}» (U6)
  - a heart for favourites (§9.6)
- **Order inside any list:**
  1. open restaurants, in the section's own order
  2. then busy and paused restaurants
  3. then closed ones, faded, at the end (U6)
- **Category page:** every restaurant of that category, in the same order.

## 8.3 Search

- One search box on «البحث», and on the home header.
- **Results:** restaurants and items, in two tabs.
  - Items show their restaurant and price.
  - Only restaurants that deliver to the selected point are searched.
  - Closed restaurants and their items come last.
- **Typing:** the search waits until typing stops.
- **Recent searches:** the last 10 (fixed), kept on the device, with «مسح».
- **No results:** «لم تجده؟ أخبرنا» opens a short form: the restaurant's name (required) and a note (optional).
  - The suggestion and the empty search feed the lost-demand report (AP §9.17).
  - The app answers «شكراً، سنحاول إضافته».

## 8.4 Delivery estimate and promised time (Q7)

The formula is shared and lives in AP §8.3. The customer sees it in two forms.

- **Before ordering** (cards, the restaurant page and checkout): a 10-minute range (fixed).
  - It starts at the estimate rounded up to 5 minutes, for example «30–40 د».
  - The estimate includes busy-mode minutes (RA §7.3).
- **While the order is `placed`:** the same range, as an indication.
- **From acceptance:** «يصل حوالي {الساعة}», which is the promised time.
  - A change by OPS updates it, with a push: «تغيّر موعد وصول طلبك إلى {الساعة}».
  - Late alerts and the automatic late code count from it (AP §8.3).
