#!/bin/bash
mkdir -p .certs

openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout .certs/nginx.key \
    -out .certs/nginx.crt

echo "SSL certificate and key generated in the '.certs' directory."
