#!/bin/bash

if id ${PUID} &>/dev/null; then
  usermod -u ${PUID} ${email_username}
  usermod -a -G users,sudo ${email_username}
  mkhomedir_helper ${email_username}
else
  useradd -m -u ${PUID} -G users,sudo -g users ${email_username}
fi

echo "${email_username}:${email_password}" | chpasswd
chown ${PUID} -R /ssl
chown ${PUID} -R /mail
chmod 774 -R /ssl
chmod 774 -R /mail

if [[ $disable_plaintext_auth != "yes" ]]; then export disable_plaintext_auth=no; fi
if [[ $ssl != "yes" && $ssl !=  "required" ]]; then export ssl=no; fi

sed -i "s/{ssl_cert}/${ssl_cert}/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/{ssl_key}/${ssl_key}/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/{ssl}/${ssl}/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/{disable_plaintext_auth}/${disable_plaintext_auth}/g" /etc/dovecot/conf.d/10-auth.conf
sed -i "s/{server_address}/${server_address}/g" /usr/share/dovecot/dovecot-openssl.cnf
if [[ $dh_pem = "yes" ]]
then
  if test -f "/etc/dovecot/dh.pem"
  then
    echo "dh.pem file exists!"
  else
    echo "Creating dh.pem file"
    openssl dhparam 4096 > /etc/dovecot/dh.pem
  fi
fi
dovecot -F
