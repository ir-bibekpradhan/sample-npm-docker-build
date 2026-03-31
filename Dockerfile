# Base image
FROM node:20-alpine

# Install OS-level dependencies (Alpine uses apk instead of apt)
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

# Default command
CMD ["npm", "start"]
