#!/usr/bin/env sh
set -euo pipefail

# Run the composer proxy in background
COMPOSER_JSON=/usr/local/bin/composer-proxy.json
if [ -f "${COMPOSER_JSON}" ]; then
  nohup /usr/local/bin/composer-proxy -c ${COMPOSER_JSON}
fi

# Ensure that the document root is writable by the "www-data" user
chown www-data:www-data /var/www/html

exec "$@"
