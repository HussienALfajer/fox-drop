# 16. Observability and analytics

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

- **Errors:** Sentry on the server, both web apps and the three Flutter apps, with release and device tags.
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
