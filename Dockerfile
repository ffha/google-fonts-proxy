FROM alpine
ENV TENGINE_VERSION 2.3.3
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add build-base openssl openssl-dev wget zlib zlib-dev make gd gd-dev geoip geoip-dev perl pcre pcre-dev
WORKDIR /usr/src
RUN wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
RUN tar zxvf tengine-${TENGINE_VERSION}.tar.gz
WORKDIR /usr/src/tengine-${TENGINE_VERSION}
RUN ./configure --prefix=/usr/share/nginx --sbin-path=/sbin/nginx --modules-path=/usr/lib/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx-error.log --pid-path=/run/nginx.pid --lock-path=/run/nginx.lock --with-select_module --with-poll_module --with-threads  --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --http-log-path=/var/log/nginx.log --http-client-body-temp-path=/tmp/client_body_temp --http-proxy-temp-path=/tmp/proxy_temp --http-fastcgi-temp-path=/tmp/fcgi_temp --http-uwsgi-temp-path=/tmp/uwsgi_temp --http-scgi-temp-path=/tmp/scgi_temp --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module --with-stream_ssl_preread_module
RUN make
RUN make install
RUN apk del zlib-dev geoip-dev pcre-dev openssl-dev gd-dev build-base
RUN rm -rf /usr/src/tengine-${TENGINE_VERSION}
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
