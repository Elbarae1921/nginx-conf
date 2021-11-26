#!/bin/bash

cat <<EOF | docker exec --interactive nginx sh
apt-get update
apt-get install certbot python3-certbot-nginx -y
certbot run -n --nginx --agree-tos -d api.skeduler.elbarae.me,www.api.skeduler.elbarae.me  -m  elbarae1921@gmail.com  --redirect'
EOF
