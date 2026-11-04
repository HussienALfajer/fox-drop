# 17. Infrastructure and environments (E8)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 17.1 Environments

| Environment   | Purpose                                                                                                                 |
| ------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `development` | Local, with Docker Compose: PostgreSQL with PostGIS, Valkey, Centrifugo, OSRM (small extract), MinIO for object storage |
| `staging`     | A smaller copy of production, used for the definition-of-done demonstrations in the four specs                          |
| `production`  | Live                                                                                                                    |

Each environment has its own database, Firebase project, storage buckets, secrets and WhatsApp sender numbers (staging uses one test number).

## 17.2 Hosting

- **Region:** Frankfurt, close to the Turkish networks that serve Azaz.
- **Provider: DigitalOcean (FRA1)** for V1:
  - application droplets running the containers (`api`, `worker`, `dispatcher`, `otp-sender`, Centrifugo, imgproxy)
  - a separate droplet for OSRM (memory-heavy)
  - **managed PostgreSQL** with a standby node and a read replica, PostGIS enabled
  - **managed Valkey**
- **Cloudflare:** DNS, CDN, WAF, R2 storage.
- Alternative if needed: Hetzner (Germany) with self-managed PostgreSQL (Patroni and pgBackRest). The containers and Terraform make the move a redeployment.

## 17.3 Deployment

- **V1–V2: Kamal** deploys the containers to the droplets with zero-downtime rolling restarts; GitHub Actions runs it on every merge to `main` (staging) and on a release tag (production).
- **From V3 (several cities): managed Kubernetes** (DOKS), with the same images, Helm charts and horizontal autoscaling of `api` and `worker`.
- **Terraform** describes every cloud resource, DNS record and bucket from the start.
- **Database migrations** run as a separate step before the new version starts; every migration is backward compatible with the running version (expand, then contract).
- Forced app updates are published outside peak hours (RA §4.2).

## 17.4 Capacity

- V1 load in one city is small (hundreds of captains send a few hundred position updates per minute). The design targets the multi-city future: stateless API, connections in Centrifugo, positions in Valkey, partitioned tables, a read replica for reports.
- A **load test with k6** and the **captain simulator** (§18.3) before launch, at five times the expected peak.
