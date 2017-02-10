#!/bin/ash

: ${HOSTS_FILE:=/etc/hosts}

current_hosts() {
    docker inspect -f '{{$root := .}}{{$i := 0}}{{range $k,$v := .NetworkSettings.Networks}}{{.IPAddress}} {{range .Aliases}}{{.}}.docker {{$root.Name}}.docker {{.}}.{{$k}}.docker{{else}}{{$root.Name}}.docker {{$root.Config.Hostname}}.docker{{end}}{{"\n"}}{{end}}' $(docker ps -q) | egrep -v '^$' | tr -d \/
}

build_hosts() {
    cat "$HOSTS_FILE" | sed '/DOCKER HOSTS/,/DOCKER HOSTS/d'
    echo '## DOCKER HOSTS ##'
    echo "$1"
    echo '## / DOCKER HOSTS ##'
}

update_hosts() {
    NEW="$(build_hosts "$(current_hosts)")" && echo "$NEW" > "$HOSTS_FILE"
    echo "Hosts file has $(wc -l < "$HOSTS_FILE") lines."
}

update_hosts

docker events | while read t n a c r; do
  [[ "$a" == "start" ]] || [[ "$a" == "stop" ]] && update_hosts
done
