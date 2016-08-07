FROM alpine:3.4

RUN apk add --no-cache certbot

VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt

COPY etc/crontab /var/spool/cron/crontabs/certbot-renew

EXPOSE 80 443

## Example: Register a new certificate
ENTRYPOINT /usr/bin/certbot certonly --standalone -d
CMD example.com
## Multi-domain certificate
CMD example.com -d example.org

## Example: Register a new certificate (full command)
ENTRYPOINT []
CMD /usr/bin/certbot certonly --standalone -d example.com

## Example: Renew certificates now
CMD /usr/bin/certbot renew --no-self-upgrade

## Default: Run this container with auto-renew twice daily
CMD /usr/sbin/crond -fd15
