FROM alpine
ENV NGINX_VERSION 1.22.0
RUN apk add gcc openssl-dev wget zlib-dev make gd-dev geoip-dev pcre2-dev git libc-dev openssl zlib pcre2 gd geoip ca-certificates
WORKDIR /usr/src
RUN git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
RUN git clone --recurse-submodules https://github.com/google/ngx_brotli
WORKDIR /usr/src
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar zxvf nginx-${NGINX_VERSION}.tar.gz
WORKDIR /usr/src/nginx-${NGINX_VERSION}
RUN addgroup -g 101 -S nginx
RUN adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
RUN ./configure --prefix=/usr/share/nginx --sbin-path=/sbin/nginx --modules-path=/usr/lib/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/dev/stderr --pid-path=/run/nginx.pid --lock-path=/run/nginx.lock --with-select_module --with-poll_module --with-threads  --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --http-log-path=/dev/stdout --http-client-body-temp-path=/tmp/client_body_temp --http-proxy-temp-path=/tmp/proxy_temp --http-fastcgi-temp-path=/tmp/fcgi_temp --http-uwsgi-temp-path=/tmp/uwsgi_temp --http-scgi-temp-path=/tmp/scgi_temp --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module --with-stream_ssl_preread_module --add-module=/usr/src/ngx_http_substitutions_filter_module --add-module=/usr/src/ngx_brotli --user=nginx --group=nginx
RUN make -j $(nproc)
RUN make install
WORKDIR /
RUN apk del zlib-dev geoip-dev pcre2-dev gd-dev gcc libc-dev git
RUN rm -rf /usr/src
COPY nginx.conf /etc/nginx/nginx.conf
CMD nginx -g "daemon off;"
