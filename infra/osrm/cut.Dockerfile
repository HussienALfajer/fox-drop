# The tools the OSRM data build needs besides OSRM (architecture §7.1): curl
# downloads the Syria extract and osmium cuts V1's region from it. The OSRM
# image is Alpine, which has no osmium-tool package.
FROM debian:trixie-slim@sha256:a72b4433de1cf7d6bae0c4cee74d0547f58601a643b3375f070c51600d63b6b2

RUN apt-get update \
  && apt-get install --yes --no-install-recommends ca-certificates curl osmium-tool \
  && rm -rf /var/lib/apt/lists/*
