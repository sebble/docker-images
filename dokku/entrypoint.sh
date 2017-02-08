#!/bin/sh
#set -xv

## Configure SSHd
test -n "$SSH_PORT" && sed -i "s/^Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config

## Configure Dokku Installer
test -n "INSTALLER_PORT" && sed -ri "s/listen\s+80/listen $INSTALLER_PORT/" /etc/nginx/conf.d/dokku-installer.conf

## Check if dokku data dir has been re-mapped
test -z "$(ls -A /home/dokku)" && rsync -av /home/dokku.src/ /home/dokku/

## Configure HOSTNAME
hostname > /home/dokku/HOSTNAME

## Check if Docker is running
docker help>/dev/null

## Check if Herokuish is configured
dpkg -l|grep herokuish|egrep '^iF'&&apt-get install -f

## Ensure sshd will work
mkdir /var/run/sshd && chmod 0755 /var/run/sshd

## Set root password
test -n "$ROOT_PASSWORD" && echo "root:$ROOT_PASSWORD" | chpasswd

## Set dokku password
test -n "$USER_PASSWORD" && echo "dokku:$USER_PASSWORD" | chpasswd

## Set Dokku HTTP port
#test -n "$DOKKU_NGINX_PORT" && dokku config:set --global DOKKU_NGINX_PORT=$DOKKU_NGINX_PORT
#test -n "$DOKKU_NGINX_SSL_PORT" && dokku config:set --global DOKKU_NGINX_SSL_PORT=$DOKKU_NGINX_SSL_PORT

## Set any other Dokku variable
set|egrep ^DOKKU_|xargs -Ix dokku config:set --global x

## Patch Upstart/SysV
test -n "$PATCH_UPSTART" && {
    echo '#!/bin/bash' > /usr/sbin/invoke-rc.d 
    echo '/etc/init.d/nginx reload' >> /usr/sbin/invoke-rc.d 
}


## Default of other?
set -xv
test "default" = "$3" && {

    ## Tail auth.log
    test -n "$TAIL_AUTH_LOG" && tail -F /var/log/auth.log &

    ## Dokku installer
    test -z "$SKIP_INSTALLER" && test -f /etc/init/dokku-installer.conf && { $(tail -1 /etc/init/dokku-installer.conf|cut -c6-) & } || rm /etc/nginx/conf.d/dokku-installer.conf

    ## Start Nginx
    test -z "$DISABLE_NGINX" && {
        tail -F /var/log/nginx/error.log 1>&2 &
        tail -F /var/log/nginx/access.log &
        /etc/init.d/nginx start &
    }

    ## Start SSHd
    /usr/sbin/sshd -De

    exit;

} || {
    exec "$@"
}
