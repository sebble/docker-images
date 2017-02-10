FROM debian:jessie
RUN apt-get update \
 && apt-get install -y nginx-extras \
 && rm -rf /var/lib/apt/lists/*
RUN rm -f /var/log/nginx/* \
 && ln -s /dev/stdout /var/log/nginx/access.log \
 && ln -s /dev/stderr /var/log/nginx/error.log
EXPOSE 80 443
CMD nginx -g "daemon off;"
