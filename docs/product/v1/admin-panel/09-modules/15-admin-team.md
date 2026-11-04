# 9.15 Admin team «فريق الإدارة» (OWN)

> Part of the [admin panel spec](../README.md) (AP). A bare "§n" here means AP §n.

- **User list:** name, phone, email, roles, status, TOTP enrolled, last sign-in, open sessions.
- **Actions:**
  - create (generates a setup link)
  - change roles (one or more per user, §6.1)
  - disable or enable
  - force sign-out
  - reset TOTP
- **Role matrix view:** read-only in V1 (§6), with the compensation cap per role editable.
