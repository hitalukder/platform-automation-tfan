FROM redis:8.4.0-alpine

# Create directory for Redis data
RUN mkdir -p /data

# Copy custom Redis configuration (optional)
# COPY redis.conf /usr/local/etc/redis/redis.conf

# Expose Redis port
EXPOSE 6379

# Set volume for data persistence
VOLUME ["/data"]

# Run Redis with appendonly mode enabled for persistence
CMD ["redis-server", "--appendonly", "yes", "--appendfilename", "appendonly.aof"]