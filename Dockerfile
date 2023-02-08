FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

