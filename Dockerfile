FROM alpine
RUN apk add tzdata tini nginx nginx-mod-brotli
COPY nginx.conf /etc/nginx/http.d/default.conf
ENV TIMEZONE=Asia/Shanghai
ENV TZ Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
RUN echo ${TZ} > /etc/timezone
COPY 404.html /usr/share/nginx/html
ENTRYPOINT ["/sbin/tini", "--"]
CMD nginx -g "daemon off;"
