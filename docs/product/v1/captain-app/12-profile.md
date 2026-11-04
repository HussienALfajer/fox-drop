# 12. Profile «ملفي»

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

## 12.1 Data and vehicle

- **Read-only:** name, phone, neighbourhood, vehicle type, plate, and the captain's FOX DROP ID number.
- **Changes** to the phone, vehicle or neighbourhood are requested through Support (§13) and made by OPS.

## 12.2 Documents

- **List:** every document with its status, issue date and expiry date.
- **Criminal record certificate (C18):** its expiry is set to the issue date plus `captain.criminal_record_validity_months` (12).
- **Expiry reminder:** `captain.document_expiry_notice_days` (30) days before a document expires, the captain gets a push and an amber banner, and OPS get a task (AP §9.7.4).
- **Replacement:** «رفع نسخة جديدة» uploads a replacement, which waits for OPS verification. The old document stays valid until it expires.
- **On expiry (K6):** an expired required document blocks going online. An expired optional document does not.

## 12.3 Contract and early exit (C17)

- **Shown:** the phase («فترة تجربة», «فترة التزام» or «مفتوح»), the start date, the probation end, the commitment end, and the contract scan (AP §9.7.2).
- **Phase changes:** each one sends a push.
- **Early exit:** the page explains what happens when a captain leaves during the commitment period:
  - there is no financial penalty
  - the kit must be returned, otherwise the deposit is withheld
  - the file is flagged «خروج مبكر», and rehiring needs the owner's approval
- **Ending the contract:** a captain who wants to stop working asks through Support. OPS run the offboarding checklist (AP §9.7.5).

## 12.4 Kit and deposit

- **Shown:** the items issued (thermal bag, vest, with sizes), the deposit paid, the instalments remaining (deducted on Thursdays), and the items returned.
- **Refund:** the deposit is refunded at offboarding when the kit is returned in good condition (AP §9.7.5).

## 12.5 Pay table and peak windows

- **Pay table:** the current table for the captain's vehicle (AP §9.12.5): base pay and the km it includes, the rate per extra km, the waiting rate, and the minimum pay.
- **Calculator:** «احسب أجري» shows the pay for a sample distance.
- **Announced changes:** they are shown at least 7 days before they apply (AP §9.12.5), with a push on announcement.
- **Peak windows (AP D15):** when the bonus is on, the days, hours, zones and amount appear here and on the home screen during a window: «مكافأة الذروة الآن: +{المبلغ} لكل طلب حتى {الساعة}».
