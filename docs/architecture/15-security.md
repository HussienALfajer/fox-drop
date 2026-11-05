# 15. Security

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 15.1 Authentication

| Product        | Method                                                                  |
| -------------- | ----------------------------------------------------------------------- |
| Admin panel    | Password (Argon2id) and TOTP, mandatory (AP §5.1)                       |
| Owner portal   | Phone and WhatsApp code (§8.3)                                          |
| Restaurant app | Phone and WhatsApp code; device registration on first sign-in (RA §5.2) |
| Captain app    | Phone and WhatsApp code; one device (CA §4.9)                           |
| Customer app   | Phone and WhatsApp code at «تأكيد الطلب» (CU §5.1–5.2)                  |

- Apps receive a short-lived access token (15 minutes, JWT signed with a rotating key) and a refresh token. Refresh tokens are stored hashed, rotated on every use, and revoked on reuse. A retry within 10 seconds of a token's first use, before its successor is used, is not a reuse: it gets a new pair that replaces the one whose answer was lost (owner decision, 2026-11-05).
- Blocking, closing an account or forcing sign-out revokes every refresh token at once (CU §5.4).

## 15.2 Authorisation

- Roles and permissions checked by NestJS guards on every route (AP §1.3 item 7). The UI hides actions, the server enforces them.
- Every query is scoped by city and by the caller's party (a restaurant sees only its orders, a captain only their tasks).
- Automated tests call every forbidden route for every role (RA §22 item 2).

## 15.3 Data protection

- TLS everywhere; HSTS on the web.
- Phone numbers encrypted at the application level in addition to disk encryption, with a searchable hash; masked by default in the panel (AP §5.4).
- Captain documents in the private bucket only (§5.8).
- Audit log append-only, enforced by database permissions (AP §4.6).

## 15.4 Secrets (E7)

- Secrets live in one environment file per environment on the server, outside the repository, readable only by that environment's system user, and reach containers as environment variables (T9). CI secrets, such as the deploy key, are GitHub Actions secrets.
- No secret in an app or a web bundle: routing, maps, WhatsApp and other keys are used only by the server (research §11 item 1).
- Provider keys entered in the panel are write-only (AP §5.4).

## 15.5 Edge protection

No Cloudflare (blocked in Syria) and no CDN in V1 (T9):

- **nginx** on the server is the only public gateway for the API, the panel, the portal and the media. Every container listens on `127.0.0.1` or a Docker network only, never on a public address (Docker bypasses the host firewall).
- TLS from Let's Encrypt, with a `CAA` record that allows only it; HSTS on the web (§15.3).
- **Rate limits** in two layers: per-IP limits in nginx (`limit_req`) on the sign-in and code routes, and the server's limits in Valkey (§5.7).
- nginx sets `X-Forwarded-For` to the client address it sees (replacing, never appending), and the API trusts exactly that one hop, so sessions, limits and the audit log record the real client address.
- fail2ban on SSH and on repeated refusals in the nginx logs; the provider's network-level DDoS protection.
- The admin panel MAY be restricted further with an IP allow-list in nginx.
