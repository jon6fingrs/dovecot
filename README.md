# dovecot

> **This repository is no longer maintained.** It has been replaced by
> [mailstack](https://github.com/jon6fingrs/mailstack), which brings mbsync,
> Dovecot 2.4 and fast full-text search together in one repo, with tested
> images for amd64 and arm64. It includes everything this repo did.
>
> Your existing mail folder works with it as is, so nothing gets downloaded
> again: see [MIGRATING.md](https://github.com/jon6fingrs/mailstack/blob/main/MIGRATING.md).
> The `thehelpfulidiot/*` images on Docker Hub stay available but won't be
> updated.

a simple docker container to set up a dovecot server for a single user

It is configured with environment variables. If you change environment variables, you will most likely need to destroy and recreate the container.

If using dh_pem, it will take a while (took like 10 minutes for me) when it first starts so that it can create the certificate. To be honest, I am not exactly sure what this does.

9/12/2024 - Updated dovecot to latest version and cleaned up the startup script a bit. Will produce errors if Solr image not found.

https://hub.docker.com/repository/docker/thehelpfulidiot/dovecot/general

See how to combine mbsync (clone remote mailbox), dovecot (serve mailbox as local IMAP server), and solr (index mailbox for better searching):
https://github.com/jon6fingrs/mbsync-dovecot
