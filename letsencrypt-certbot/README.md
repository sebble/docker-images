## Usage

**Do not use as-is, needs persistent volume or missing compose file**

### Set up a Certbot container

See example compose file at https://github.com/sebble/docker-images/

    docker-compose up -d

### Register new domain

    docker run --rm -it sebble/letsencrypt-certbot-alpine \
        certbot \
        certonly \
        --standalone \
        --text \
        --email email@example.com \
        --agree-tos \
        --standalone-supported-challenges http-01 \
        --domains example.com

Explanation:

    docker exec -it nginx_certbot_1              # run a disposable container

        certbot                                  # run `certbot`

        certonly                                 # we write our own configs

        --standalone                             # auth method

        --text                                   # disable ncurses interface

        --email email@example.com                # this is usually req'd

        --agree-tos                              # this is always req'd

        --standalone-supported-challenges http-01   # disable :443 check

        --domains example.com                    # the domain we are reg'ing

