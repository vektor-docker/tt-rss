#!/usr/bin/env bash

./compose.sh up --force-recreate --abort-on-container-exit
./compose.sh down
