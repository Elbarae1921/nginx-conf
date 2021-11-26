#!/bin/bash

docker exec nginx "apk update &&
                   apk add certbot certbot-nginx &&
                   certbot run -n --nginx --agree-tos -d api.skeduler.elbarae.me,www.api.skeduler.elbarae.me  -m  elbarae1921@gmail.com  --redirect"
