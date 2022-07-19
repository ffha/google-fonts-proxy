FROM alpine
ENV NGINX_VERSION 1.22.0
RUN apk add gcc openssl openssl-dev wget zlib zlib-dev make gd gd-dev geoip geoip-dev perl pcre2 pcre2-dev tini git libc-dev
WORKDIR /usr/src
RUN git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
RUN git clone --recurse-submodules https://github.com/google/ngx_brotli
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar zxvf nginx-${NGINX_VERSION}.tar.gz
WORKDIR /usr/src/nginx-${NGINX_VERSION}
RUN ./configure --prefix=/usr/share/nginx --sbin-path=/sbin/nginx --modules-path=/usr/lib/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/dev/stderr --pid-path=/run/nginx.pid --lock-path=/run/nginx.lock --with-select_module --with-poll_module --with-threads  --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --http-log-path=/dev/stdout --http-client-body-temp-path=/tmp/client_body_temp --http-proxy-temp-path=/tmp/proxy_temp --http-fastcgi-temp-path=/tmp/fcgi_temp --http-uwsgi-temp-path=/tmp/uwsgi_temp --http-scgi-temp-path=/tmp/scgi_temp --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module --with-stream_ssl_preread_module --add-module=/usr/src/ngx_http_substitutions_filter_module --add-module=/usr/src/ngx_brotli
RUN make -j $(nproc)
RUN make install
RUN apk del zlib-dev geoip-dev pcre2-dev openssl-dev gd-dev gcc wget libc-dev
RUN rm -rf /usr/src/tengine-${TENGINE_VERSION}
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/src/*
ENTRYPOINT ["/sbin/tini", "--"]
CMD nginx -g "daemon off;"
