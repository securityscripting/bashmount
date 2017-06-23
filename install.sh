install -m700 bashmount-au/bashmount-au /usr/bin/bashmount-au
install -m600 bashmount-au/bashmount-au.conf /etc/bashmount-au.conf
install -m600 mediawatch.sh /usr/bin/mediawatch.sh
install -m600 logk3b.sh /usr/bin/logk3b.sh
mkdir /usr/share/bashmount-au
install -m600 bashmount-au/bashmount-au.functions /usr/share/bashmount-au/bashmount-au.functions
install -m644 bashmount-au.1.gz /usr/share/man/man1/bashmount-au.1.gz
rpm -qa | grep inotify-tools
if [ $? != 0 ]; then
  echo "inotify-tools is not installed. Data transfer's cannot be audited"
fi
