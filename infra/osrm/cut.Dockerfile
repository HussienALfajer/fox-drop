# The tools the OSRM data build needs besides OSRM (architecture §7.1): curl
# downloads the Syria extract and osmium cuts V1's region from it. The OSRM
# image is Alpine, which has no osmium-tool package.
FROM debian:trixie-slim@sha256:8aa5a7bf5a1955bddbe7d74fcdd0b91ab30e74362a8b73af672b0481b35b44a0

RUN apt-get update \
  && apt-get install --yes --no-install-recommends ca-certificates curl osmium-tool \
  && rm -rf /var/lib/apt/lists/*
