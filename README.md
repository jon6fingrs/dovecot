# dovecot
a simple docker container to set up a dovecot server for a single user

It is configured with environment variables. If you change environment variables, you will most likely need to destroy and recreate the container.

If using dh_pem, it will take a while (took like 10 minutes for me) when it first starts so that it can create the certificate. To be honest, I am not exactly sure what this does.

9/12/2024 - Updated dovecot to latest version and cleaned up the startup script a bit.

https://hub.docker.com/repository/docker/thehelpfulidiot/dovecot/general

See how to combine mbsync (clone remote mailbox), dovecot (serve mailbox as local IMAP server), and solr (index mailbox for better searching):
https://github.com/jon6fingrs/mbsync-dovecot
