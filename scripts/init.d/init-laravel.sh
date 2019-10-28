#!/usr/bin/env bash
set -e

if [[ "${ENABLE_LARAVEL_CONFIG_CACHE}" == "true" ]]; then
    echo "init laravel config:cache"
    php artisan config:cache
    echo "init laravel route:cache"
    php artisan route:cache
fi

echo "set storage directory 777"
find . -name "storage" -type d -exec chmod -R 777 {} \;

echo "set bootstrap directory 777"
find . -name "bootstrap" -type d -exec chmod -R 777 {} \;
