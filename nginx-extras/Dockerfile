FROM debian:jessie
RUN apt-get update \
 && apt-get install -y nginx-extras \
 && rm -rf /var/lib/apt/lists/*
EXPOSE 80 443
CMD nginx -g "daemon off;"
