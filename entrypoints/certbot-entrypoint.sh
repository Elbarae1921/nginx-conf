#!/bin/sh

if [ -e /etc/nginx/dhparam/dhparam.pem ]; then
    echo "DH Parameter already exists"
else
    echo "Generating DH Parameter"
    openssl dhparam -out /etc/nginx/dhparam/dhparam.pem 2048
fi

while sleep 12h; do wait $$; certbot renew; done
