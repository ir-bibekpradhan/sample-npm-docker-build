FROM node:20-bullseye

# Install OS-level dependencies (important for native npm modules)
RUN apt-get update && \
    apt-get install -y \
      python3 \
      make \
      g++ \
      curl \
      git \
      libvips-dev \
      tiemu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency files first
COPY package*.json tsconfig.json ./

# Install npm dependencies (this will be heavy now)
RUN npm install

# Copy source
COPY . .

# Build inside container
RUN npm run build

CMD ["npm", "start"]
