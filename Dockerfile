# ---------------- Stage 1: Builder ----------------
FROM node:20-alpine AS builder

# Install OS-level dependencies (Alpine uses apk)
RUN apk add --no-cache \
      python3 \
      make \
      g++ \
      curl \
      git \
      vips-dev

WORKDIR /app

# HTTP request to verify network inside container
RUN curl -sS https://jsonplaceholder.typicode.com/posts/1

# Copy dependency files first
COPY package*.json tsconfig.json ./

# Install Node dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# ---------------- Stage 2: Final ----------------
FROM node:20-alpine AS final
WORKDIR /app

# Copy built artifacts from builder stage
COPY --from=builder /app /app

# Default command
CMD ["npm", "start"]
