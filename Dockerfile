FROM alpine
RUN apk add tzdata tini openssl curl ca-certificates sudo
RUN printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | sudo tee -a /etc/apk/repositories
RUN curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
RUN openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout
RUN mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/
RUN apk add nginx@nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
ENV TIMEZONE=Asia/Shanghai
ENV TZ Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
RUN echo ${TZ} > /etc/timezone
COPY 404.html /usr/share/nginx/html
ENTRYPOINT ["/sbin/tini", "--"]
CMD nginx
