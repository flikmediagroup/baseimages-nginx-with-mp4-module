FROM alpine:3.11

LABEL Maintainer Markku Virtanen

ENV NGINX_VERSION nginx-1.18.0

COPY mp4module.patch /tmp/mp4module.patch

RUN apk --update add openssl-dev git pcre-dev zlib-dev tini wget build-base && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxvf ${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/${NGINX_VERSION} && \
    patch /tmp/src/${NGINX_VERSION}/src/http/modules/ngx_http_mp4_module.c /tmp/mp4module.patch && \
    ./configure \
        --with-http_ssl_module \
        --with-http_mp4_module \
        --with-http_gzip_static_module \
        --prefix=/etc/nginx \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx && \
    make && \
    make install && \
    apk del build-base && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*