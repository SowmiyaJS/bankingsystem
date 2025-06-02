# Builder stage
FROM node:18-alpine AS builder

# Create a non-root user
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -D appuser

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Create and set permissions for /app/data
RUN mkdir -p /app/data && chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Runner stage
FROM node:18-alpine AS runner

# Create same non-root user
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -D appuser

WORKDIR /app

# Copy app from builder stage
COPY --from=builder /app /app

# Ensure /app/data exists and has correct ownership
RUN mkdir -p /app/data && chown -R appuser:appgroup /app/data

USER appuser

ENV PORT=8080
EXPOSE 8080


CMD ["npm", "start"]
