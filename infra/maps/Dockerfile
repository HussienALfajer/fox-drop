# The tools of the map build (architecture §7.2, infra/maps/build.sh): the
# pmtiles CLI, built from its pinned module, which extracts Azaz's region from
# a Protomaps daily build by range requests, and curl for the glyphs and the
# sprite.
FROM golang:1.25-alpine@sha256:1ae0735f00daffa3aaf1363a5184c0d2dc55c78e3db4ec70241cdac97bf84b59 AS pmtiles
RUN CGO_ENABLED=0 go install github.com/protomaps/go-pmtiles@v1.31.2

FROM debian:trixie-slim@sha256:a72b4433de1cf7d6bae0c4cee74d0547f58601a643b3375f070c51600d63b6b2
RUN apt-get update \
  && apt-get install --yes --no-install-recommends ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*
COPY --from=pmtiles /go/bin/go-pmtiles /usr/local/bin/pmtiles
COPY build.sh style.json /maps/
