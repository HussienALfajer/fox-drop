# One image for the four server roles (architecture §4.4); PROCESS_ROLE picks
# the role at start. Build from the repository root:
#   docker build -f apps/server/Dockerfile -t fox-drop-server .

FROM node:26.13.0-trixie-slim AS build
WORKDIR /repo
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml tsconfig.base.json ./
# The pnpm version comes from packageManager, like everywhere else.
RUN npm install --global "$(node -p "require('./package.json').packageManager")"
COPY apps/server/package.json apps/server/
RUN pnpm install --frozen-lockfile --filter @fox-drop/server
COPY apps/server apps/server
RUN pnpm --filter @fox-drop/server build \
  && pnpm --filter @fox-drop/server deploy --prod /out \
  && cp -r apps/server/dist /out/dist

FROM node:26.13.0-trixie-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /out/package.json ./
COPY --from=build /out/node_modules node_modules
COPY --from=build /out/dist dist
# Applied by `node dist/database/migrate-command.js` as its own deploy step
# (architecture §17.3), with MIGRATION_DATABASE_URL set.
COPY --from=build /repo/apps/server/migrations migrations
USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]
