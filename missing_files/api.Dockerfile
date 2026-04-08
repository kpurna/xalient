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


# 3) Runtime image
FROM node:20-alpine AS runner
ENV NODE_ENV=production
ENV DATABASE_URL=postgres://postgres:postgres@postgres:5432/postgres
ENV LOG_LEVEL=info

WORKDIR /app

COPY --from=prod-bundle /out/ ./
COPY --from=build /repo/apps/api/scripts/start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 3000

CMD ["./start.sh"]
