FROM ubuntu:latest
#ENV email_username="username"
#ENV email_password="password"
#ENV UID="1000"
#ENV disable_plaintext_auth="yes"
# yes or no
#ENV ssl_cert="dovecot.pem"
#ENV ssl_key="dovecot.pem"
#ENV ssl="required"
#yes, no, or required
#ENV server_address="imap.example.com"
RUN apt update && apt upgrade -y
RUN apt install -y dovecot-imapd
RUN apt install -y openssl
RUN apt install -y ca-certificates nano

RUN mkdir /var/log/dovecot
RUN touch /var/log/dovecot/dovecot.log
RUN touch /var/log/dovecot/error.log
RUN ln -sf /dev/stdout /var/log/dovecot/dovecot.log \
	&& ln -sf /dev/stderr /var/log/dovecot/error.log
COPY log-rotate /etc/logrotate.d/dovecot
# COPY etc/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
COPY 15-mailboxes.conf /etc/dovecot/conf.d/15-mailboxes.conf
COPY 10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf
COPY 10-auth.conf /etc/dovecot/conf.d/10-auth.conf
COPY dovecot-openssl.cnf /usr/share/dovecot/dovecot-openssl.cnf
COPY 10-mail.conf /etc/dovecot/conf.d/10-mail.conf
RUN mkdir /ssl
RUN mkdir /mail
VOLUME /ssl /mail /var/log/dovecot
# VOLUME /etc/dovecot /usr/share/dovecot 

EXPOSE 993

COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]