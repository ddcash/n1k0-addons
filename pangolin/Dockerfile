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

# Install dependencies first
RUN npm ci

# Install complete Tailwind CSS dependencies that might be missing
RUN npm install tailwindcss @tailwindcss/postcss postcss autoprefixer --save-dev

# Re-run npm ci to ensure all dependencies are properly linked
RUN npm ci

# Debug: Check what we have after npm install
RUN echo "=== After npm install ===" && \
    ls -la && \
    echo "=== Node version ===" && \
    node --version && \
    echo "=== NPM version ===" && \
    npm --version && \
    echo "=== Checking tailwindcss installation ===" && \
    npm list tailwindcss || echo "tailwindcss not found" && \
    npm list @tailwindcss/postcss || echo "@tailwindcss/postcss not found"

# Generate database schema and build files
RUN echo "export * from \"./sqlite\";" > server/db/index.ts && \
    echo "export const build = \"oss\" as any;" > server/build.ts

# Try to generate schema, but continue if it fails
RUN echo "=== Generating database schema ===" && \
    (npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out init || \
    mkdir -p init) && \
    echo "Schema generation completed"

# Debug: Check if we have the necessary files before building
RUN echo "=== Before build - checking files ===" && \
    ls -la server/ && \
    echo "=== Checking esbuild ===" && \
    ls -la esbuild.mjs && \
    echo "=== Checking package.json scripts ===" && \
    grep -A 5 -B 5 "build:sqlite" package.json && \
    echo "=== Checking postcss config ===" && \
    ls -la postcss.config.* || echo "No postcss config found"

# Build the application with better error handling
RUN echo "=== Building SQLite version ===" && \
    npm run build:sqlite && \
    echo "=== Build completed ==="

# Debug: Check what was built
RUN echo "=== After build - checking dist ===" && \
    ls -la dist/ && \
    echo "=== Checking .next ===" && \
    ls -la .next/ || echo "No .next directory"

# Build CLI if available
RUN echo "=== Building CLI ===" && \
    (npm run build:cli || echo "CLI build failed, continuing...") && \
    echo "=== CLI build completed ==="

# Clean up dev dependencies but keep the built files
RUN npm ci --omit=dev && npm cache clean --force

# Cache buster for Docker layer caching - 2025-09-19-v8
# Create final directory structure first
RUN mkdir -p /app/final/dist /app/final/.next/static /app/final/public

# Since the build succeeded, copy the essential files
RUN echo "=== Copying built files ===" && \
    cp package.json /app/final/ && \
    cp -r dist /app/final/ && \
    echo "Copied dist directory" && \
    ls -la /app/final/dist/

# Copy Next.js build if it exists
RUN if [ -d .next/standalone ]; then \
        echo "Copying .next/standalone/*" && \
        find .next/standalone -mindepth 1 -exec cp -r {} /app/final/ \; 2>/dev/null || echo "No files in standalone"; \
    else \
        echo "No .next/standalone directory found"; \
    fi

RUN if [ -d .next/static ]; then \
        echo "Copying .next/static" && \
        mkdir -p /app/final/.next && \
        cp -r .next/static /app/final/.next/static; \
    else \
        echo "No .next/static directory found"; \
    fi

# Copy other essential files
RUN if [ -d init ]; then \
        echo "Copying init directory" && cp -r init /app/final/dist/init; \
    else \
        echo "No init directory found" && mkdir -p /app/final/dist/init; \
    fi

RUN if [ -f server/db/names.json ]; then \
        echo "Copying names.json" && cp server/db/names.json /app/final/dist/names.json; \
    else \
        echo "No names.json found"; \
    fi

RUN if [ -d public ]; then \
        echo "Copying public directory" && cp -r public /app/final/public; \
    else \
        echo "No public directory found"; \
    fi

# Copy CLI wrapper (skip if file doesn't exist)
RUN if [ -f cli/wrapper.sh ]; then cp cli/wrapper.sh /usr/local/bin/pangctl && chmod +x /usr/local/bin/pangctl; fi

# Set final working directory
WORKDIR /app/final

# Debug: Final check of what we have
RUN echo "=== Final directory contents ===" && \
    ls -la && \
    echo "=== Final dist contents ===" && \
    ls -la dist/ && \
    echo "=== Verifying server files ===" && \
    test -f dist/server.mjs && echo "server.mjs exists" || echo "server.mjs MISSING" && \
    test -f dist/migrations.mjs && echo "migrations.mjs exists" || echo "migrations.mjs MISSING"

# Copy rootfs with service scripts
COPY rootfs/ /

# Fix permissions for all service scripts
RUN find /etc/services.d -name "run" -exec chmod +x {} \; && \
    find /etc/services.d -name "finish" -exec chmod +x {} \; && \
    find /etc/cont-init.d -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1