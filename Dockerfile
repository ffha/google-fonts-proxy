FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN apk add tzdata tini
ENV TIMEZONE=Asia/Shanghai
ENV TZ Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
RUN echo ${TZ} > /etc/timezone
COPY 404.html /usr/share/nginx/html
ENTRYPOINT ["/sbin/tini", "--"]
CMD nginx
