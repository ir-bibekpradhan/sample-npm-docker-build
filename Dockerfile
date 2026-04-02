# ── Stage 1: Builder (Debian Bullseye — full build tools) ────────────────────
FROM node:20-bullseye AS builder

RUN apt-get update && \
    apt-get install -y \
      python3 \
      make \
      g++ \
      curl \
      git \
      libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json tsconfig.json ./

# Install all deps (including devDependencies needed for build)
RUN npm ci

COPY . .

RUN npm run build

# Prune to production deps only before copying to runtime
RUN npm prune --production

# ── Stage 2: Runtime (Alpine — lightweight, different OS) ────────────────────
FROM node:20-alpine AS runtime

# Install only runtime-required native libs (needed by sharp/libvips)
RUN apk add --no-cache \
      vips \
      curl

WORKDIR /app

# Copy only what's needed to run — not source, not devDeps, not build tools
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

CMD ["node", "dist/index.js"]
