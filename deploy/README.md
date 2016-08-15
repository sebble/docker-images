# Light-weight deployment environment

## Description

Docker image based on Alpine linux with a few extra packages suitable for remote deployments (FTPS, SFTP).

## Packages

- `openssh-client`
- `wget`
- `curl`
- `lftp`
- `rsync`

## Examples

### SFTP + Rsync

**.gitlab-ci.yml**:

```
image: sebble/deploy

before_script:
    - ## http://docs.gitlab.com/ce/ci/ssh_keys/README.html
    - eval $(ssh-agent -s)
    - ssh-add <(echo "$SSH_PRIVATE_KEY")

deploy:
    stage: deploy
    script:
        - ash deploy.sh
    environment: production
```

**deploy.sh**:

```
#!/bin/sh
: ${REMOTE_USER:="your_remote_username"}
: ${REMOTE_HOST:="your_remote_hostname"}
: ${LOCAL_DIR:="public_html/"}
: ${REMOTE_DIR:="public_html/"}

echo Adding $REMOTE_HOST to known_hosts...
ssh-keyscan -H $REMOTE_HOST >> ~/.ssh/known_hosts
## or:
# -o StrictHostKeyChecking=no
# -o UserKnownHostsFile=/dev/null

echo Deploying via SSH...
rsync -av -e ssh "$LOCAL_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
```

### FTP(S)

**.gitlab-ci.yml**:

```
image: sebble/deploy

deploy:
    stage: deploy
    script:
        - ash deploy.sh
    environment: production
```

**deploy.sh**:

```
#!/bin/sh
: ${FTP_SERVER:="your_remote_hostname"}
: ${FTP_USER:="your_remote_username"}
: ${LOCAL_DIR:="public_html"}
: ${REMOTE_DIR:="public_html"}
: ${FTP_PASSWORD:?}

echo Deploying via FTP...
lftp -u "$FTP_USER,$FTP_PASSWORD" $FTP_SERVER -e "mirror -R --delete $LOCAL_DIR $REMOTE_DIR; bye"
```
