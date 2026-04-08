# 1) Build stage
FROM node:20-alpine AS build
WORKDIR /repo

RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

COPY pnpm-workspace.yaml pnpm-lock.yaml package.json turbo.json ./
COPY packages ./packages
COPY apps/api ./apps/api

RUN pnpm install --frozen-lockfile

# Build API
RUN printf '{\n  "extends": "./tsconfig.json",\n  "compilerOptions": {\n    "noEmit": false,\n    "allowImportingTsExtensions": false,\n    "outDir": "./dist"\n  }\n}\n' > apps/api/tsconfig.build.json \
  && pnpm -C apps/api exec tsc -p tsconfig.build.json


# 2) Production bundle
FROM node:20-alpine AS prod-bundle
WORKDIR /repo

RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

COPY pnpm-workspace.yaml pnpm-lock.yaml package.json ./
COPY packages ./packages
COPY apps/api ./apps/api

RUN pnpm deploy /out --filter api --prod --ignore-scripts

COPY --from=build /repo/apps/api/dist /out/dist

# Copy migrations folder so migrate.js can find it at runtime
COPY --from=build /repo/apps/api/src/db/migrations /out/dist/src/db/migrations


# 3) Runtime image
FROM node:20-alpine AS runner
ENV NODE_ENV=production
ENV DATABASE_URL=postgres://postgres:postgres@postgres:5432/postgres
ENV LOG_LEVEL=info

WORKDIR /app

COPY --from=prod-bundle /out/ ./

# Write startup script inline - no external file dependency
RUN printf '#!/bin/sh\nset -e\n\necho "Dropping existing tables..."\nnode dist/src/db/drop-all-tables.js\n\necho "Running migrations..."\nnode dist/src/db/migrate.js\n\necho "Seeding database..."\nnode dist/src/db/seed.js --alerts=200 --changes=100 --interfaces=200 --inventory=30 --smarts_discovery_status_rgt=10 --settings=3\n\necho "Starting API server..."\nexec node dist/src/index.js\n' > /app/start.sh \
  && chmod +x /app/start.sh

EXPOSE 3000

CMD ["/app/start.sh"]
