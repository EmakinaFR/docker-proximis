#!/usr/bin/env sh
set -euo pipefail

# Ensure that the document root is writable by the "www-data" user
chown www-data:www-data /var/www/html

exec "$@"
