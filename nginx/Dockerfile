FROM nginx:alpine

LABEL maintainer="EmakinaFR <team-proximis@emakina.fr>"

# Install Nginx requirements
RUN \
    apk add --no-cache shadow && \
    apk add --no-cache --virtual .build-deps openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -subj '/CN=localhost' -days 365 -x509 -newkey rsa:4096 -nodes \
        -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt && \
    apk del .build-deps

RUN \
    usermod -u 1000 nginx && \
    groupmod -g 1000 nginx

WORKDIR /var/www/html/
