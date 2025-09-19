ARG BUILD_FROM
FROM $BUILD_FROM

# Install Node.js and dependencies
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl \
    python3 \
    make \
    g++ \
    sqlite

# Set environment variables
ENV NODE_ENV=production
ENV ENVIRONMENT=prod
ENV DATABASE=sqlite

# Create app directory
WORKDIR /app

# Clone Pangolin repository
RUN git clone https://github.com/fosrl/pangolin.git .

# Install dependencies
RUN npm ci

# Generate database schema
RUN echo "export * from \"./sqlite\";" > server/db/index.ts
RUN echo "export const build = \"oss\" as any;" > server/build.ts
RUN npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out init

# Build the application
RUN npm run build:sqlite
RUN npm run build:cli

# Clean up dev dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy built files to final structure
RUN mkdir -p /app/final/dist && \
    cp -r .next/standalone/* /app/final/ && \
    cp -r .next/static /app/final/.next/static && \
    cp -r dist/* /app/final/dist/ && \
    cp -r init /app/final/dist/init && \
    cp server/db/names.json /app/final/dist/names.json && \
    cp -r public /app/final/public

# Copy CLI wrapper (skip if file doesn't exist)
RUN if [ -f cli/wrapper.sh ]; then cp cli/wrapper.sh /usr/local/bin/pangctl && chmod +x /usr/local/bin/pangctl; fi

# Set final working directory
WORKDIR /app/final

# Copy run script
COPY rootfs/ /
RUN chmod +x /etc/cont-init.d/* /etc/services.d/*/run

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1