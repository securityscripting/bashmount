. ./bashmount-au/bashmount-au.conf


if [ `id -u` != "0" ]; then
  echo "Install required as root user"
  exit 1
fi

if [ "${enable_logging}" == "yes" ]; then
  touch "${logfile}"
fi

install -m700 bashmount-au/bashmount-au /usr/bin/bashmount-au
install -m600 bashmount-au/bashmount-au.conf /etc/bashmount-au.conf
install -m700 mediawatch.sh /usr/bin/mediawatch.sh
install -m700 logk3b.sh /usr/bin/logk3b.sh
mkdir /usr/share/bashmount-au
install -m600 bashmount-au/bashmount-au.functions /usr/share/bashmount-au/bashmount-au.functions
install -m644 bashmount-au.1.gz /usr/share/man/man1/bashmount-au.1.gz
install -m644 bashmount-au.desktop /usr/share/applications/bashmount-au.desktop
rpm -qa | grep inotify-tools >/dev/null
if [ $? != 0 ]; then
  echo "inotify-tools is not installed. Data transfer's cannot be audited"
fi
rpm -qa | grep k3b >/dev/null
if [ $? != 0 ]; then
  echo "k3b is not installed. Optical media cannot be burned"
fi
  chmod -R 770  /usr/bin/wodim 2> /dev/null
  chmod -R 770  /usr/bin/brasero 2> /dev/null
  chmod -R 770  /usr/lib64/brasero 2> /dev/null
  chmod -R 770  /usr/bin/k3b 2> /dev/null

  chown root:$group_auth  /usr/bin/wodim 2> /dev/null
  chmod root:$group_auth  /usr/bin/brasero 2> /dev/null
  chmod root:$group_auth  /usr/lib64/brasero 2> /dev/null
  chmod root:$group_auth  /usr/bin/k3b 2> /dev/null


