# Base image
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
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Optional HTTP request (can be uncommented if needed)
RUN curl -sS https://jsonplaceholder.typicode.com/posts/1

# Copy dependency files first
COPY package*.json tsconfig.json ./

# Install Node dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Default command
CMD ["npm", "start"]
