# 18. Open items (these do not block the build)

> Part of the [customer app spec](README.md) (CU). A bare "§n" here means CU §n.

1. **Store availability in Syria.** *Closed* (technology-stack T3, 2026-11-04): the Apple Developer, Google Play and Firebase accounts are available. Store review requirements are handled at submission. The APK on the website serves phones without Google Play.
2. **Phone numbers in Azaz.** Check which numbers customers use most, Turkish or Syrian, to set `customer.phone_default_country`. Test WhatsApp code delivery to both.
3. **Maps for customers.** *Decided* (technology-stack §7.2): MapLibre with OpenStreetMap tiles; place search is not needed in V1. Before launch, check the OSM map quality of Azaz's neighbourhoods; if it is clearly weaker than Google Maps, the pin screen may use Google Maps for display only.
4. **Privacy policy.** It must say that gender and birthday are collected and why, and what happens to data after account closure (AP §13 item 6).
5. **Push in Azaz.** The Firebase account is available (technology-stack T3). As RA §21 item 2: still test FCM and APNs delivery on real devices and networks.
6. **Neighbourhood names.** Name the zones as people in Azaz name their neighbourhoods, because customers see the zone name in addresses and restaurants see it on orders.
