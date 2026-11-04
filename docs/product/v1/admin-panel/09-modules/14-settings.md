# 9.14 Settings «الإعدادات»

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

- **Grouped screens:** timers and limits, dispatch, customers, captains, restaurants, support, finance, security, apps. Every setting from Appendix A appears on its group screen with its default, current value, unit, description, and «استعادة الافتراضي» (restore default).
- **Apps «التطبيقات»:** for each of the customer, restaurant and captain apps:
  - minimum version: older versions are forced to update
  - latest version: suggest updating
  - update message
  - maintenance mode with its message, per app
- **OTP and messaging:**
  - channel for app sign-in codes: WhatsApp only in V1 (technology-stack T4, T5). SMS and voice are not offered. Codes have 6 digits in every app (fixed, customer-app spec Q4).
  - OTP validity, attempts and resend wait, and the request and sending limits (Appendix A)
  - «أرقام إرسال الرموز» (code-sending numbers, OWN): add a WhatsApp number and pair it by scanning a QR code, see its state (warming, active, standby, throttled, disconnected, banned) and its daily counts, set it active or standby, and disable it (technology-stack §8.3.3)
  - provider keys (OWN, write-only)
- Every change is audited, and settings with money impact ask for a reason.
