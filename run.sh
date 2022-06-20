#!/bin/bash
#usermod -u ${PUID} ${email_username}
useradd -m -u ${PUID} -G users,sudo -g users ${email_username}
echo "${email_username}:${email_password}" | chpasswd
chown ${PUID} -R /ssl
chown ${PUID} -R /mail
chmod 644 -R /ssl
chmod 644 -R /mail
#sed -i "s/{ssl_cert}/${ssl_cert}/g" /etc/dovecot/conf.d/10-ssl.conf
#sed -i "s/{ssl_key}/${ssl_key}/g" /etc/dovecot/conf.d/10-ssl.conf
#sed -i "s/{ssl}/${ssl}/g" /etc/dovecot/conf.d/10-ssl.conf
#sed -i "s/{disable_plaintext_auth}/${disable_plaintext_auth}/g" /etc/dovecot/conf.d/10-auth.conf
#sed -i "s/{server_address}/${server_address}/g" /usr/share/dovecot/dovecot-openssl.cnf
dovecot -F