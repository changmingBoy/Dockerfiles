#!/usr/bin/env bash
docker build rabbitMQ/ --build-arg "HTTPS_PROXY=http://10.2.236.32:1087" -t changmingjiang/rabbitmq:latest