# Ledger check and restore

Read when the task needs it; the short rules are in `SKILL.md`.

## Check an order's money in the ledger

`infra/server/check-order-ledger.sql` checks a delivered order's journals against AP §8.4 and lists its entries (read-only; the owner's run in `docs/runbooks/staging-cycle.md`). As root on the server, with the order's number:

```bash
docker exec -i foxdrop-staging-postgres-1 psql -U postgres -d fox_drop -v number=<order number> < /srv/foxdrop-staging/current/infra/server/check-order-ledger.sql
```

## Restore a backup

The files: set the `RCLONE_CONFIG_FOXDROP*` variables as `backup.sh` does (`foxdropcrypt` and `foxdropstorage`, the latter with the server's key `STORAGE_KEY_ID`/`STORAGE_SECRET`, since the backup key may not write), then `rclone copy foxdropcrypt:public-media foxdropstorage:public-media` and `rclone copy foxdropcrypt:private-docs foxdropstorage:private-docs` (the captain documents, the restaurants' scans and the report photos; slice 2.34a). It only adds missing objects. The database:

1. Copy the dump back, if it is not in `/var/backups/foxdrop-staging/`: set the `RCLONE_CONFIG_FOXDROP*` variables as `backup.sh` does, then `rclone copyto foxdropcrypt:<name> /var/backups/foxdrop-staging/<name>`.
2. Try it on a throwaway database first: `docker run -d --name foxdrop-restore-test -e POSTGRES_PASSWORD=x <the postgis image>`, then `docker exec -i foxdrop-restore-test pg_restore --username postgres --dbname postgres --create --no-owner --no-privileges < <dump>` and check the tables; remove the container.
3. Replacing staging's database stops staging and is destructive: ask the owner first. Stop OSRM before `docker compose down` on an environment (`docker compose --project-name foxdrop-osrm --project-directory /srv/foxdrop-osrm stop`, then `up --detach` after): `down` tries to remove the environment's OSRM network.
