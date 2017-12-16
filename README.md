# Docker образ [TT-RSS](https://tt-rss.org/)

[ ![Download](https://api.bintray.com/packages/vektory79/docker/vektory79%3Att-rss/images/download.svg) ](https://bintray.com/vektory79/docker/vektory79%3Att-rss/_latestVersion)
[![Build Status](https://travis-ci.org/vektor-docker/tt-rss.svg?branch=master)](https://travis-ci.org/vektor-docker/tt-rss)

## Введение
Данный образ базируется на образе [javister-docker-php](https://github.com/javister/javister-docker-php)
и содержит приложение [TT-RSS](https://tt-rss.org/) для аггрегации новостных лент в 
формате RSS и ATOM.

## Запуск
Для работы этого образа необходимы база данных и Nginx. В качестве примера запуска
приложения можно использовать файл [docker-compose.yaml](https://github.com/vektor-docker/tt-rss/blob/master/docker-compose.yaml)
из репозитария данного образа. В данном примере используются следующие образы:

* vektory79/tt-rss - данное приложение
* [javister-docker-postgresql](https://github.com/javister/javister-docker-postgresql) - 
  База данных PostgreSQL
* [javister-docker-nginx]() - сервер Nginx для маршрутизации HTTP запросов в 
  FastCGI запросы к PHP-FPM
* [javister-docker-docker-gen]() - вспомогательный инструмент для автоматической 
  генерации конфигурации. В данном случае - гонфигурации Nginx.

## Параметры образа

Данный образ можно конфигурировать через передачу параметров окружения. Помимо 
параметров от образа javister-docker-php, данный поддерживает следующие параметры:

* RUN_INSTALL - принимает значения `yes` (по умолчанию) или `no`. Если установлено 
  занчение `no`, то стандартный мастер инсталляции TT-RSS запускаться не будет, а
  конфигурация будет всзята из параметров запуска, описываемых далее.
* DB_TYPE - тип базы данных. Принимает значение `pgsql` или `mysql`. По умолчанию - `pgsql`
* DB_HOST - адрес или имя хоста сервера БД. По умолчанию `localhost`.
* DB_PORT - порт БД. По умолчанию `5432`.
* DB_NAME - имя БД, которая должна быть создана перед запуском БД. По умолчанию `tt-rss`.
* DB_USER - логин БД, под которым будет работать приложение. По умолчанию `system`.
* DB_PASS - пароль БД, под которым будет работать приложение. По умолчанию `system`.
* SELF_URL_PATH - URL под которым приложение будет доступно из интернет. По умолчанию `http://localhost/tt-rss/`.
  