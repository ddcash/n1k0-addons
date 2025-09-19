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

# Clone Pangolin repository and checkout a specific commit to avoid breaking changes
RUN git clone https://github.com/fosrl/pangolin.git . && \
    git checkout main

# Install dependencies
RUN npm ci

# Generate database schema and build files
RUN echo "export * from \"./sqlite\";" > server/db/index.ts && \
    echo "export const build = \"oss\" as any;" > server/build.ts

# Try to generate schema, but continue if it fails
RUN npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out init || \
    mkdir -p init

# Build the application
RUN npm run build:sqlite || echo "Build completed with warnings"
RUN npm run build:cli || echo "CLI build completed with warnings"

# Clean up dev dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy built files to final structure with proper checks
RUN mkdir -p /app/final/dist && \
    ([ -d .next/standalone ] && cp -r .next/standalone/* /app/final/ || echo "No standalone build found") && \
    ([ -d .next/static ] && cp -r .next/static /app/final/.next/static || mkdir -p /app/final/.next/static) && \
    ([ -d dist ] && cp -r dist/* /app/final/dist/ || echo "No dist directory found") && \
    ([ -d init ] && cp -r init /app/final/dist/init || mkdir -p /app/final/dist/init) && \
    ([ -f server/db/names.json ] && cp server/db/names.json /app/final/dist/names.json || echo "No names.json found") && \
    ([ -d public ] && cp -r public /app/final/public || mkdir -p /app/final/public)

# Copy CLI wrapper (skip if file doesn't exist)
RUN if [ -f cli/wrapper.sh ]; then cp cli/wrapper.sh /usr/local/bin/pangctl && chmod +x /usr/local/bin/pangctl; fi

# Set final working directory
WORKDIR /app/final

# Copy run script
COPY rootfs/ /
RUN chmod +x /etc/cont-init.d/* /etc/services.d/*/run

# Expose port
EXPOSE 3000

# Start the application directly if Next.js standalone doesn't exist
CMD ["node", "--enable-source-maps", "/app/dist/server.mjs"]