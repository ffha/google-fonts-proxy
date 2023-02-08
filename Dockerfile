FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/templates/default.conf.template
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

