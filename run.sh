#!/bin/bash
set -e

# --- USER SETUP ---
# Check if someone already has the desired UID
existing_user_with_uid=$(getent passwd "${PUID}" | cut -d: -f1)

if id "${email_username}" &>/dev/null; then
  # email_username exists
  current_uid=$(id -u "${email_username}")
  if [[ "${current_uid}" != "${PUID}" ]]; then
    echo "Changing UID of '${email_username}' from ${current_uid} to ${PUID}"
    usermod -u "${PUID}" "${email_username}"
  fi
else
  if [[ -n "${existing_user_with_uid}" && "${existing_user_with_uid}" != "${email_username}" ]]; then
    echo "Renaming user '${existing_user_with_uid}' to '${email_username}' to take over UID ${PUID}"
    usermod -l "${email_username}" "${existing_user_with_uid}"
    usermod -d "/home/${email_username}" -m "${email_username}"
  else
    echo "Creating user '${email_username}' with UID ${PUID}"
    useradd -m -u "${PUID}" -g users -G sudo "${email_username}"
  fi
fi

# Ensure group membership
for group in users sudo; do
  if ! id -nG "${email_username}" | grep -qw "$group"; then
    usermod -a -G "$group" "${email_username}"
  fi
done

# Set password
echo "${email_username}:${email_password}" | chpasswd

# --- FILE PERMISSIONS ---
chown "${PUID}" -R /ssl
chown "${PUID}" -R /mail
chmod 774 -R /ssl
chmod 774 -R /mail

# --- SSL CONFIG ---
if [[ $auth_allow_cleartext != "yes" ]]; then export auth_allow_cleartext=no; fi
if [[ $ssl != "yes" && $ssl !=  "required" ]]
then
  export ssl=no
  sed -i "s/ssl_cert = </#ssl_cert = </g" /etc/dovecot/conf.d/10-ssl.conf
  sed -i "s/ssl_key = </#ssl_key = </g" /etc/dovecot/conf.d/10-ssl.conf
fi

# --- SUBSTITUTIONS ---
sed -i "s/{ssl_cert}/${ssl_cert}/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/{ssl_key}/${ssl_key}/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/{ssl}/${ssl}/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/{auth_allow_cleartext}/${auth_allow_cleartext}/g" /etc/dovecot/conf.d/10-auth.conf
sed -i "s/{server_address}/${server_address}/g" /usr/share/dovecot/dovecot-openssl.cnf

# --- DH PARAM ---
if [[ $dh_pem = "yes" ]]
then
  if test -f "/etc/dovecot/dh.pem"
  then
    echo "dh.pem file exists!"
  else
    echo "Creating dh.pem file."
    echo "This will take a while."
    openssl dhparam 4096 > /etc/dovecot/dh.pem
  fi
else
  sed -i "s/ssl_server_dh_file = /#ssl_server_dh_file = /g" /etc/dovecot/conf.d/10-ssl.conf
fi

# --- START DOVECOT ---
dovecot -F
