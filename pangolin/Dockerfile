ARG BUILD_FROM
FROM $BUILD_FROM

# Install Node.js and dependencies
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl

# Set working directory
WORKDIR /app

# Clone Pangolin repository
RUN git clone https://github.com/fosrl/pangolin.git .

# Install dependencies
RUN npm install

# Set up database configuration for SQLite build
RUN echo "export * from \"./sqlite\";" > server/db/index.ts && \
    echo "export const build = \"oss\" as any;" > server/build.ts

# Generate database schema for SQLite - try multiple output locations
RUN npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out init || true
RUN npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out dist/init || true  
RUN npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out server/migrations || true

# Build using the correct Pangolin build commands (SQLite version)
RUN npm run build:sqlite

# Copy the required names.json file to dist directory
RUN cp server/db/names.json dist/names.json || echo '[]' > dist/names.json

# Set up migration directories in all possible locations
RUN mkdir -p dist/migrations/meta dist/init/meta init/meta server/migrations/meta && \
    echo '{"version":"5","dialect":"sqlite","entries":[]}' > dist/migrations/meta/_journal.json && \
    echo '{"version":"5","dialect":"sqlite","entries":[]}' > dist/init/meta/_journal.json && \
    echo '{"version":"5","dialect":"sqlite","entries":[]}' > init/meta/_journal.json && \
    echo '{"version":"5","dialect":"sqlite","entries":[]}' > server/migrations/meta/_journal.json

# Copy any generated migration files to the expected locations
RUN find . -name "*.sql" -path "*/migrations/*" -exec cp {} dist/migrations/ \; 2>/dev/null || true
RUN find . -name "*.sql" -path "*/init/*" -exec cp {} dist/migrations/ \; 2>/dev/null || true

# Update the run script to handle data directory
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose port 3003
EXPOSE 3003

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3003/ || exit 1

# Start the application
CMD ["/run.sh"]