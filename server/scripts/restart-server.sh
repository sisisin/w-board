#!/usr/bin/env bash

readonly rev=$1

docker kill $(docker ps -q)
docker run -idt -p 80:3000 sisisin/w-board:$rev
