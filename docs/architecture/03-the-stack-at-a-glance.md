# 3. The stack at a glance

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

| Layer | Choice |
|---|---|
| **Server runtime** | Node.js (current LTS), TypeScript in strict mode |
| **Server framework** | NestJS on the Fastify adapter, as a modular monolith |
| **Database** | PostgreSQL (latest stable) with PostGIS and `pg_trgm` |
| **Jobs and timers** | pg-boss (queue and scheduled jobs inside PostgreSQL) |
| **Cache, locks, rate limits, live positions** | Valkey (Redis-compatible), including GEO commands |
| **Real time** | Centrifugo (WebSocket server with history and recovery) |
| **API** | REST with OpenAPI 3.1; generated Dart and TypeScript clients |
| **Routing and distances** | OSRM, self-hosted, with OpenStreetMap data for Syria |
| **Map display** | MapLibre (web and Flutter) with OpenStreetMap vector tiles |
| **Push** | Firebase Cloud Messaging (Android, and iOS through APNs) |
| **Sign-in codes** | WhatsApp through a third-party library, isolated in the `otp-sender` worker (§8.3) |
| **App integrity** | Firebase App Check (Play Integrity on Android, App Attest on iOS) |
| **Files and images** | S3-compatible object storage (Cloudflare R2) with imgproxy behind the CDN |
| **Admin panel and owner portal** | React, TypeScript, Vite (single-page apps), TanStack Router, Query and Table, Base UI, Tailwind CSS |
| **Restaurant app** | Flutter for Android and Windows, with native Kotlin and Win32 layers for ringing |
| **Customer app** | Flutter for Android and iOS |
| **Captain app** | Flutter for Android and iOS, with `flutter_background_geolocation` and native Kotlin and Swift layers for offers |
| **Errors** | Sentry (server, web, Flutter) |
| **Metrics, logs, traces** | OpenTelemetry, then Grafana, Prometheus, Loki and Tempo |
| **Product analytics** | PostHog |
| **Hosting** | Docker containers on DigitalOcean (Frankfurt, FRA1) with managed PostgreSQL and managed Valkey; Cloudflare in front |
| **CI/CD** | GitHub Actions; Kamal for V1 deployments, managed Kubernetes from V3 |
| **Infrastructure as code** | Terraform |
