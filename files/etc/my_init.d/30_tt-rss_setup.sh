#!/usr/bin/env bash
 set -e

mkdir -p \
    /config/tt-rss/lock \
    /config/tt-rss/cache/images \
    /config/tt-rss/cache/upload \
    /config/tt-rss/cache/export \
    /config/tt-rss/cache/js
#    /config/tt-rss/feed-icons \
chown -R system:system /config/tt-rss /app/tt-rss
chmod -R 777 /config/tt-rss /app/tt-rss

# wait for DB
wait4tcp ${DB_HOST} ${DB_PORT}

function sedescape {
  echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g'
}

if [ "${RUN_INSTALL}" == "no" ]; then
    cp /app/tt-rss/config.php-dist /app/tt-rss/config.php

    sed --in-place "s/define.'DB_TYPE', .*/define('DB_TYPE', \"$(sedescape ${DB_TYPE})\");/g" /app/tt-rss/config.php
    sed --in-place "s/define.'DB_HOST', .*/define('DB_HOST', \"$(sedescape ${DB_HOST})\");/g" /app/tt-rss/config.php
    sed --in-place "s/define.'DB_USER', .*/define('DB_USER', \"$(sedescape ${DB_USER})\");/g" /app/tt-rss/config.php
    sed --in-place "s/define.'DB_NAME', .*/define('DB_NAME', \"$(sedescape ${DB_NAME})\");/g" /app/tt-rss/config.php
    sed --in-place "s/define.'DB_PASS', .*/define('DB_PASS', \"$(sedescape ${DB_PASS})\");/g" /app/tt-rss/config.php
    sed --in-place "s/define.'DB_PORT', .*/define('DB_PORT', \"$(sedescape ${DB_PORT})\");/g" /app/tt-rss/config.php
    sed --in-place "s/define.'SELF_URL_PATH', .*/define('SELF_URL_PATH', '$(sedescape ${SELF_URL_PATH})');/g" /app/tt-rss/config.php
    sed --in-place "s/define.'PHP_EXECUTABLE', .*/define('PHP_EXECUTABLE', '\\/opt\\/remi\\/php${PHP_VERSION}\\/root\\/usr\\/bin\\/php');/g" /app/tt-rss/config.php
    sed --in-place "s/define.'LOCK_DIRECTORY', .*/define('LOCK_DIRECTORY', '\\/config\\/tt-rss\\/lock');/g" /app/tt-rss/config.php
    sed --in-place "s/define.'CACHE_DIR', .*/define('CACHE_DIR', '\\/config\\/tt-rss\\/cache');/g" /app/tt-rss/config.php
#    sed --in-place "s/define.'ICONS_DIR', .*/define('ICONS_DIR', '\\/config\\/tt-rss\\/feed-icons');/g" /app/tt-rss/config.php
#    sed --in-place "s/define.'ICONS_URL', .*/define('ICONS_URL', '\\/config\\/tt-rss\\/feed-icons');/g" /app/tt-rss/config.php
    sed --in-place "s/define.'SPHINX_SERVER', .*/define('SPHINX_SERVER', '$(sedescape ${SPHINX_SERVER})');/g" /app/tt-rss/config.php
    sed --in-place "s/define.'SPHINX_INDEX', .*/define('SPHINX_INDEX', '$(sedescape ${SPHINX_INDEX})');/g" /app/tt-rss/config.php

    # Wait for DB
    sleep 5

    cd /app/tt-rss/install
    php${PHP_VERSION} autoinit.php
fi
