FROM debian:jessie

RUN apt-get update \
 && apt-get install -y wget apt-transport-https openssh-server \
 \
 && wget -nv -O - https://get.docker.com/ | sh \
 \
 && wget -nv -O - https://packagecloud.io/gpg.key | apt-key add - \
 && echo "deb https://packagecloud.io/dokku/dokku/ubuntu/ trusty main" > /etc/apt/sources.list.d/dokku.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y dokku || true \
 && sed -i 's/half-configured/installed/g' /var/lib/dpkg/status \
 \
 && rm -rf /var/lib/apt/lists/* \
 \
 && mkdir -p /dokku-src/{home,data,plugins} && chown -R dokku:dokku /dokku-src \
 && rsync -av /home/dokku/ /dokku-src/home/ \
 && rsync -av /var/lib/dokku/ /dokku-src/dokku/

VOLUME /home/dokku
VOLUME /var/lib/dokku
VOLUME /etc/ssh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD default
