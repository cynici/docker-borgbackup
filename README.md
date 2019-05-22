# Dockerized borgbackup 

Adapted from:

- https://github.com/b3vis/docker-borgmatic - use of latest Borg pip package and fuse-mount borg repository

- https://github.com/tgbyte/docker-borg-backup - use of non-root user running as a borg server

## Caveat and recommendations

- `borg config /path/to/repo additional_free_space 2G` https://borgbackup.readthedocs.io/en/stable/quickstart.html#important-note-about-free-space

- Set environment variable `BORGUSER_UID`, https://borgbackup.readthedocs.io/en/stable/quickstart.html#important-note-about-permissions


alpine adduser
https://github.com/mhart/alpine-node/issues/48

## Prerequisite

- borgserver (target backup server) must have compatible version of Borg software installed.

- Restrict client SSH key on borgserver to borg command in authorized_keys file like so:

```
command="borg serve --restrict-to-path ~/repo",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding,restrict ssh-rsa ...
```

- Use dedicated SSH key on client in ~/.ssh/config:

```
Host borgserver
  IdentityFile ~/.ssh/dedicated_borg_private_key
  IdentitiesOnly yes
  # https://borgbackup.readthedocs.io/en/stable/usage/serve.html#ssh-configuration
  ServerAliveInterval 10
  ServerAliveCountMax 30
```

## Usage

Run this command as the backup user on the client machine:

```
# Will prompt for passphrase
docker run --rm -it -e BORGUSER_UID=$(id -u) -v $HOME:/home/borg cheewai/docker-borgbackup borg init --encryption=repokey-blake2 borg@borgserver:~/repos/...
```

