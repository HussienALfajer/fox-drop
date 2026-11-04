# 13. Open items (these do not block the build)

> Part of the [admin panel spec](README.md) (AP). A bare "§n" here means AP §n.

1. **Early exit from a captain's contract.** _Decided_ (captain-app spec C17): no financial penalty in V1, the kit is returned or the deposit is withheld, and rehiring needs OWN's approval (§9.7.2).
2. **A restaurant that does not pay on Saturday.** With D26 the platform collects commission from restaurants after the fact, so a restaurant can fall behind. The panel raises the overdue alert (§8.7) and leaves the action to OWN. Still to decide: should the restaurant be paused automatically after a number of days, or above a maximum unpaid amount?
3. **Captain cash at pickup.** _Decided_ (captain-app spec C4): each captain sets the most they can pay a restaurant, and dispatch does not offer them larger orders (§9.12.6). Operations should still brief captains on carrying enough cash.
4. **Azaz base currency.** Chosen when the city is created (D25). Verify on the ground which currency restaurants price in. Until then the development and staging seeds use a value marked as a placeholder; the production value is set after the field check (owner, 2026-11-04).
5. **Values to enter before launch:**
   - default commission and launch commission (proposed 15%, and 10% for the first 20 restaurants for 3 months)
   - the delivery fee table
   - captain pay tables
   - suggested cash limits per vehicle
   - the late-delivery compensation value
   - the fake-order dues rule (proposed: delivery fee + merchant net)
   - rounding units
   - minimum order
6. **Data retention after account closure (D19).** App store rules expect personal data to be deleted when a user deletes their account, unless retention is needed for fraud prevention, security or legal and financial records. Before submitting to the stores, check that keeping all data is acceptable. If not, keep only what fraud prevention and financial records need (phone, device, orders, ledgers, blocks), and say so in the privacy policy.
7. **Document validity.** _Decided_ (captain-app spec C18): the criminal record certificate is valid for 12 months from its issue date, with the usual 30-day expiry task.
8. **Distance service.** _Decided_ (technology-stack §7.1, 2026-11-04): self-hosted OSRM with OpenStreetMap data for Syria. The straight-line fallback stays for when OSRM does not answer.
9. **Tax.** V1 has no tax line. If local rules require one, it will be added to the order money (§8.4) as its own line.
