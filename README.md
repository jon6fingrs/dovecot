# dovecot

This is a simple docker container with an instance of dovecot intended to serve emails to a single user. Dovecot is capable of much more than is being utilized in this container. This container was made as a companion to the mbsync container so that emails from a remote server could be synced locally and re-served by an imap server.

I did not write and have no affiliation with the authors of dovecot. I only created this container.

https://www.dovecot.org/

## Configuration

This container was designed to be configured through environment variables. If you want to configure the application beyond those, you can always mount the following two directories, and manually edit the configuration files.

```
/etc/dovecot

/usr/share/dovecot
```
