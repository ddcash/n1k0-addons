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

# Generate database schema for SQLite
RUN npx drizzle-kit generate --dialect sqlite --schema ./server/db/sqlite/schema.ts --out init || mkdir -p init

# Build using the correct Pangolin build commands (SQLite version)
RUN npm run build:sqlite

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start the application
CMD ["/run.sh"]