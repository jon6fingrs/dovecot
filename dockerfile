FROM ubuntu:latest

RUN apt update && apt upgrade -y
RUN apt install -y dovecot-imapd
RUN apt install -y openssl
RUN apt install -y ca-certificates nano curl gpg apt-transport-https

RUN mkdir -p /etc/apt/keyrings; curl https://repo.dovecot.org/DOVECOT-REPO-GPG | gpg --import
RUN gpg --export ED409DA1 > /etc/apt/keyrings/dovecot.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/dovecot.gpg] https://repo.dovecot.org/ce-2.3-latest/ubuntu/focal focal main" >> /etc/apt/sources.list.d/dovecot.list

RUN apt update

RUN apt install -y dovecot-imapd
RUN apt install -y dovecot-solr

RUN touch /var/log/dovecot-info.log
RUN touch /var/log/dovecot.log
RUN ln -sf /dev/stdout /var/log/dovecot-info.log \
        && ln -sf /dev/stderr /var/log/dovecot.log
COPY log-rotate /etc/logrotate.d/dovecot
COPY log-rotate-info /etc/logrotate.d/dovecot-info

# COPY etc/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
COPY 15-mailboxes.conf /etc/dovecot/conf.d/15-mailboxes.conf
COPY 10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf
COPY 10-auth.conf /etc/dovecot/conf.d/10-auth.conf
COPY dovecot-openssl.cnf /usr/share/dovecot/dovecot-openssl.cnf
COPY 10-mail.conf /etc/dovecot/conf.d/10-mail.conf

COPY 90-plugin.conf /etc/dovecot/conf.d/90-plugin.conf
COPY 10-logging.conf /etc/dovecot/conf.d/10-logging.conf
COPY 10-master.conf /etc/dovecot/conf.d/10-master.conf

RUN mkdir /ssl
RUN mkdir /mail
#RUN mkdir /mail/Important
#RUN chmod 777 -R /ssl
RUN chmod 777 -R /mail
VOLUME /ssl /mail /var/log/dovecot
# VOLUME /etc/dovecot /usr/share/dovecot 

EXPOSE 993

COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
