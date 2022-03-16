FROM debian:bullseye-slim

RUN set -x \
    && addgroup --system --gid 101 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx

RUN apt-get update && \
    apt-get install wget build-essential libpcre3-dev libssl-dev tar zlib1g-dev libgd-dev -y

RUN wget http://nginx.org/download/nginx-1.20.2.tar.gz

RUN wget https://github.com/nbs-system/naxsi/archive/1.3.tar.gz -O naxsi

RUN tar -xvf nginx-1.20.2.tar.gz

RUN tar -xvf naxsi

WORKDIR /nginx-1.20.2

RUN ./configure \
    --conf-path=/etc/nginx/nginx.conf \
    --add-module=../naxsi-1.3/naxsi_src/ \
    --error-log-path=/var/log/nginx/error.log \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-log-path=/var/log/nginx/access.log \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-stream=dynamic \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_addition_module \
    --without-mail_pop3_module \
    --without-mail_smtp_module \
    --without-mail_imap_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --modules-path=/etc/nginx/modules \
    --prefix=/usr

RUN make

RUN make install

RUN cp ../naxsi-1.3/naxsi_config/naxsi_core.rules /etc/nginx/

RUN mkdir -p /var/lib/nginx/body
RUN mkdir -p /var/cache/nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# for convenience when ssh-ing into container
WORKDIR /

COPY . /etc/nginx/

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
