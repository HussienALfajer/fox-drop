# 17. Infrastructure and environments (E8)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 17.1 Environments

| Environment   | Purpose                                                                                                                                                                                                                |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `development` | Local, with Docker Compose: PostgreSQL with PostGIS, Valkey, Centrifugo (`compose.yaml`). OSRM over Azaz's region behind the `osrm` profile (slice 1.3); an S3-compatible object storage joins with its first use (T7) |
| `staging`     | A smaller copy of production on the same server (T9), used for the definition-of-done demonstrations in the four specs                                                                                                 |
| `production`  | Live                                                                                                                                                                                                                   |

Each environment has its own database, Firebase project, storage buckets, secrets and WhatsApp sender numbers (staging uses one test number).

## 17.2 Hosting (T9)

- **Server:** the owner's existing Contabo server (Ubuntu 24.04, 6 vCPU, about 12 GB of memory, about 200 GB of disk, in Contabo's EU region), shared with the owner's other sites. Cloudflare is blocked in Syria, so every client reaches this server directly.
- **Staging and production both run there**, isolated from each other and from the other sites: one system user, one Docker Compose project and network, one database, one set of buckets and one environment file each.
- **Containers per environment:** `api`, `worker`, `dispatcher`, `otp-sender`, Centrifugo, imgproxy, the object storage (§5.8), PostgreSQL with PostGIS, and Valkey. OSRM (memory-heavy, map data only) runs once and serves both environments.
- **nginx**, already on the server, is the only public gateway, with Let's Encrypt certificates (§15.5). It serves each web app's static files with its `index.html` for every unknown path outside `/v1`, routes `/v1` on each web app's host to the API (so the session cookie stays on its own origin), and routes the API, the real-time connections and the media to their containers.
- **PostgreSQL** is self-managed in its container, with no standby node and no read replica in V1. Continuous WAL archiving and nightly base backups (pgBackRest), encrypted, go to a destination off the server, reached from the server only; a restore is tested before launch. Valkey holds nothing that cannot be rebuilt (E2).
- **DNS:** the domain is not bought yet. Its provider is chosen when it is bought; it needs `A` records for the API, the panel, the portal and the media hosts, and a `CAA` record for Let's Encrypt.
- **Moving later:** when load, a second city (§20) or the shared server's limits require it, the same images and Compose files move to a dedicated server; the containers make the move a redeployment.

## 17.3 Deployment

- **V1: Docker Compose over SSH.** GitHub Actions builds the images, pushes them to the GitHub container registry, then on the server pulls them and restarts the environment's Compose project: on every merge to `main` (staging) and on a release tag (production). A deploy restarts each container briefly, so production deploys happen outside peak hours.
- The Compose files, the nginx configuration and the deploy scripts live in `infra/`. No Terraform in V1: the only resources are the one server and the DNS records, which `infra/` documents.
- **Database migrations** run as a separate step before the new version starts; every migration is backward compatible with the running version (expand, then contract).
- Forced app updates are published outside peak hours (RA §4.2).
- Hosting is revisited before several cities run (V3, §20): dedicated servers or a managed Kubernetes, with the same images.

## 17.4 Capacity

- V1 load in one city is small (hundreds of captains send a few hundred position updates per minute). The design targets the multi-city future: stateless API, connections in Centrifugo, positions in Valkey, partitioned tables, and a read replica for reports once one is needed (none in V1, §17.2).
- A **load test with k6** and the **captain simulator** (§18.3) before launch, at five times the expected peak.
