FROM javister-docker-docker.bintray.io/javister/javister-docker-git:1.0 as GIT

RUN cd /app && \
    chmod 0777 /app && \
    git-docker clone https://tt-rss.org/git/tt-rss.git tt-rss

FROM javister-docker-docker.bintray.io/javister/javister-docker-php:72
MAINTAINER Viktor Verbitsky <vektory79@gmail.com>

COPY --from=GIT /app /app/
COPY files /

ENV HOME="/app" \
    LOG_LEVEL="INFO" \
    RPMLIST="php${PHP_VERSION}-php-pecl-apcu php${PHP_VERSION}-php-gd php${PHP_VERSION}-php-json php${PHP_VERSION}-php-pgsql php${PHP_VERSION}-php-mbstring php${PHP_VERSION}-php-xml" \
    RUN_INSTALL="yes" \
    DB_TYPE="pgsql" \
    DB_HOST="localhost" \
    DB_PORT="5432" \
    DB_NAME="tt-rss" \
    DB_USER="system" \
    DB_PASS="system" \
    SELF_URL_PATH="http://localhost/tt-rss/" \
    SPHINX_SERVER="localhost:9312" \
    SPHINX_INDEX="ttrss, delta"

RUN . /usr/local/bin/yum-proxy && \
    yum-install && \
    yum-clean && \
    chmod --recursive --changes +x /etc/my_init.d/*.sh /etc/service /usr/local/bin
