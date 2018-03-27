FROM redis:latest

LABEL maintainer="EmakinaFR <team-proximis@emakina.fr>"

# Install custom Redis configuration
COPY redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
