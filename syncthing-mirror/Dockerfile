FROM debian:jessie
MAINTAINER Sebastian Mellor
RUN apt-get update \
 && apt-get install -y curl apt-transport-https \
 && curl -s https://syncthing.net/release-key.txt|apt-key add - \
 && echo "deb https://apt.syncthing.net/ syncthing release">/etc/apt/sources.list.d/syncthing.list \
 && apt-get update \
 && apt-get install -y syncthing \
 && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
 && apt-get install -y xmlstarlet \
 && rm -rf /var/lib/apt/lists/*
VOLUME /root/.config/syncthing
EXPOSE 80 22000 21025/udp
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD syncthing --no-browser --no-restart --gui-address http://0.0.0.0:80
