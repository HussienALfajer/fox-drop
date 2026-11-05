# 16. Observability and analytics

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

- **Errors:** Sentry on the server, both web apps and the three Flutter apps, with release and device tags.
- **Reached through FOX DROP's domain (T9):** networks in Syria may not reach Sentry or PostHog, so the web apps and the Flutter apps send their events to a relay path on FOX DROP's domain (Sentry's `tunnel` option, and a reverse proxy for PostHog), which the server forwards. No phone calls Sentry, PostHog or Grafana Cloud directly; the server reaches them from the hosting region.
- **Metrics, logs, traces:** OpenTelemetry in the server; Grafana with Prometheus (metrics), Loki (logs) and Tempo (traces), hosted (Grafana Cloud) in V1.
- **Business health dashboards and alerts for the technical team:**
  - time from `placed` to accepted, and from ready to pickup
  - rings not handled, offers expired, receiving-device count per open restaurant
  - Centrifugo connections and recoveries, outbox lag, timer lag
  - location update lag per captain
  - WhatsApp sender states and delivery rates (§8.3.3)
  - ledger reconciliation result (§5.6)
- **Product analytics:** PostHog (EU cloud in V1, self-hosted later if needed), with funnels for browse → cart → checkout → placed. No keystroke recording.
- **Logs** never contain codes, tokens or full phone numbers.
