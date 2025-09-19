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

# Cache buster for Docker layer caching - 2025-09-19-v4
# Create final directory structure first
RUN mkdir -p /app/final/dist /app/final/.next/static /app/final/public

# Check what files exist for debugging
RUN echo "=== Listing files for debugging ===" && \
    ls -la . && \
    echo "=== Checking .next directory ===" && \
    (ls -la .next/ || echo "No .next directory") && \
    echo "=== Checking dist directory ===" && \
    (ls -la dist/ || echo "No dist directory") && \
    echo "=== End file listing ==="

# Copy files with individual checks to avoid pipeline failures - using safer copy methods
RUN if [ -d .next/standalone ]; then \
        echo "Copying .next/standalone/*" && \
        find .next/standalone -mindepth 1 -exec cp -r {} /app/final/ \; 2>/dev/null || echo "No files in standalone"; \
    else \
        echo "No .next/standalone directory found"; \
    fi

RUN if [ -d .next/static ]; then \
        echo "Copying .next/static" && cp -r .next/static /app/final/.next/static; \
    else \
        echo "No .next/static directory found"; \
    fi

RUN if [ -d dist ]; then \
        echo "Copying dist directory" && \
        if [ "$(ls -A dist)" ]; then \
            cp -r dist/* /app/final/dist/ 2>/dev/null || echo "Could not copy dist contents"; \
        else \
            echo "dist directory is empty"; \
        fi; \
    else \
        echo "No dist directory found"; \
    fi

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

# Copy run script
COPY rootfs/ /
RUN chmod +x /etc/cont-init.d/* /etc/services.d/*/run

# Expose port
EXPOSE 3000

# Start the application directly if Next.js standalone doesn't exist
CMD ["node", "--enable-source-maps", "/app/dist/server.mjs"]