# The panel and the portal in one image (architecture §17.2), served by an
# unprivileged nginx. Build from the repository root:
#   docker build -f infra/web/Dockerfile -t fox-drop-web .

FROM node:26.13.0-trixie-slim AS build
WORKDIR /repo
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml tsconfig.base.json ./
# The pnpm version comes from packageManager, like everywhere else.
RUN npm install --global "$(node -p "require('./package.json').packageManager")"
COPY apps/admin/package.json apps/admin/
COPY apps/merchant-portal/package.json apps/merchant-portal/
COPY packages/api-schema/package.json packages/api-schema/
RUN pnpm install --frozen-lockfile --filter @fox-drop/admin... --filter @fox-drop/merchant-portal...
COPY packages/api-schema packages/api-schema
COPY apps/admin apps/admin
COPY apps/merchant-portal apps/merchant-portal
RUN pnpm --filter @fox-drop/admin --filter @fox-drop/merchant-portal build

FROM nginxinc/nginx-unprivileged:1.31.7-alpine
LABEL org.opencontainers.image.source=https://github.com/HussienALfajer/fox-drop
COPY infra/web/nginx.conf /etc/nginx/conf.d/default.conf
COPY infra/web/spa.conf /etc/nginx/foxdrop-spa.conf
COPY --from=build /repo/apps/admin/dist /usr/share/nginx/admin
COPY --from=build /repo/apps/merchant-portal/dist /usr/share/nginx/merchant-portal
EXPOSE 8080 8081
