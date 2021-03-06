#!/usr/bin/env bash
set -e

if [[ "${PARAMS}" == "php" ]]; then
    # if exist config file, will skip generate
    # to fix:
    #    when container been mount new config files via readonly volumes will trigger ERROR
    #
    if [ ! -f /usr/local/etc/php/php.ini ]; then
        envsubst $replaces < "/conf-temp/php.ini-production.temp" > "/usr/local/etc/php/php.ini" 
    fi

    if [ ! -f /usr/local/etc/php-fpm.conf ]; then
        cp /conf-temp/php-fpm.conf.temp /usr/local/etc/php-fpm.conf
    fi

    if [[ "${PHP_ENABLE_LARAVEL_CONFIG_CACHE}" == "true" ]]; then
        echo "init laravel config:cache"
        php artisan config:cache
        echo "init laravel route:cache"
        php artisan route:cache
    fi

    # set PHP_RW_DIRECTORY=/srv/a,/srv/b,/srv/c
    # will set /srv/a, /srv/b, /srv/c 777
    if [[ "${PHP_RW_DIRECTORY}" ]]; then
        t_arr=(${PHP_RW_DIRECTORY//,/ })
        for directory in ${t_arr[@]}; do
            echo "check directory $directory";
            mkdir -p ${directory};
            
            echo "set directory: $directory 777";
            chmod -R 777 ${directory};
        done
    fi
fi
