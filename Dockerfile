# Use Debian-based Node.js image as base
FROM node:20-bullseye

# Install OS-level dependencies for Debian (important for native npm modules)
RUN apt-get update && \
    apt-get install -y \
      python3 \
      make \
      g++ \
      curl \
      git \
      libvips-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Alpine-based packages too (using the Alpine package manager)
RUN apt-get update && \
    apt-get install -y \
      curl \
      wget \
      ca-certificates \
      libc6-compat \
    && rm -rf /var/lib/apt/lists/*

# Testing HTTP requests to valid URLs (you can replace these URLs with real ones you want to test)
RUN curl -sS https://jsonplaceholder.typicode.com/posts/1 | jq .

# Create and set working directory
WORKDIR /app

# Copy dependency files first
COPY package*.json tsconfig.json ./

# Install npm dependencies (this will be heavy now)
RUN npm install

# Copy source code
COPY . .

# Build inside container
RUN npm run build

# Default command to run the app
CMD ["npm", "start"]
