# OSRM and object storage

Read when the task needs it; the short rules are in `SKILL.md`.

## OSRM (shared by every environment)

One Compose project, `foxdrop-osrm`, in `/srv/foxdrop-osrm` (copied from `infra/osrm/` by `provision.sh`): four routed services over Azaz's region, about 15 MB each. Each environment's server containers reach them on that environment's `foxdrop-osrm-<env>` network as `http://osrm-<vehicle>:5000`; while they are down, the API measures the straight line × 1.3.

- **Build:** `provision.sh` builds the data on its first run (several minutes: the 82 MB Syria extract, the cut, four profiles); `foxdrop-osrm-build.timer` rebuilds it every Monday at 04:30 and restarts the services. By hand, as root: `foxdrop-osrm-build`. The cut peaks at about 1.5 GB of memory for a minute.
- **Status and logs:** `docker ps --filter label=com.docker.compose.project=foxdrop-osrm`; `journalctl -u foxdrop-osrm-build`; `docker logs foxdrop-osrm-osrm-car-1`.
- **A failed build** leaves the running data in place (the new data is swapped in only after all four profiles build).

## Object storage and images (architecture §5.8, slice 2.5)

- **Containers:** `storage` (Garage, S3 API on 127.0.0.1:3114) and `imgproxy` (127.0.0.1:3115). The deploy starts `storage` with the database and runs `storage-setup` after the migrations: the one-node layout, the server's and the reader's keys (`STORAGE_KEY_ID`/`STORAGE_SECRET`, `STORAGE_READER_KEY_ID`/`STORAGE_READER_SECRET`) and the `public-media` bucket; it changes nothing once they exist.
- **Secrets first:** the storage's six lines (`GARAGE_RPC_SECRET`, `GARAGE_ADMIN_TOKEN` and the two keys) are added by `provision.sh`. The first deploy that has the storage fails at Compose's interpolation until they exist: provision from that commit on `main`, then run `foxdrop-deploy staging <the same commit>` again. Garage never changes a key's secret: to replace a key, remove both its lines from `shared/.env`, run `provision.sh` (a new ID) and deploy.
- **Check:** `curl -sI https://<API host>/media/_/w320/plain/<a key from the panel>` answers `200` with `Content-Type: image/webp`; a width other than 160, 320, 640 or 1280 answers `404`. Garage's own status: `docker exec foxdrop-staging-storage-1 /garage status`.
- **The cache:** nginx keeps imgproxy's results for 30 days, 2 GB at most; a key is never reused, so nothing goes stale. Emptying it is safe (`rm -rf /var/cache/nginx/foxdrop-staging-media/*`, then `systemctl reload nginx`).
