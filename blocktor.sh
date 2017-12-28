#!/bin/bash
checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
    printf "Run this program as root!\n"
    exit 1
fi
}
start() {

checkroot
declare -a dependencies=("ipset");
for package in "${dependencies[@]}"; do
   if ! hash "$package" 2> /dev/null; then
     printf "'$package' isn't installed. apt-get install -y '$package'\n";
     exit 1
   fi
done
YOUR_IP=$(curl -s ifconfig.me)
printf "Configuring ipset..."
ipset -q -N tor iphash
wget -q https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$YOUR_IP -O - | sed '/^#/d' | while read IP
do
ipset -q -A tor $IP
done
if [ ! -d "/etc/iptables" ]; then
mkdir "/etc/iptables"
ipset -q save -f /etc/iptables/ipset.rules
printf "Done (saved: /etc/iptables/ipset.rules\n"
fi
ipset -q save -f /etc/iptables/ipset.rules
printf "Done (saved: /etc/iptables/ipset.rules\n"
printf "Configuring iptables..."
checkiptables=$(iptables --list | grep "tor src")
if [[ $checkiptables == "" ]]; then
iptables -A INPUT -m set --match-set tor src -j DROP;
fi
if [ ! -e "/etc/iptables/rules.v4" ]; then
touch "/etc/iptables/rules.v4"
iptables-save > /etc/iptables/rules.v4
printf "Done (saved: /etc/iptables/rules.v4\n"
else
iptables-save > /etc/iptables/rules.v4
printf "Done (saved: /etc/iptables/rules.v4\n"
fi
}
remove() {
checkroot
iptables -D INPUT -m set --match-set tor src -j DROP
ipset destroy tor
printf "Rules removed\n"
}

case "$1" in --start) start ;; --remove) remove ;; *)
printf "Usage: sudo ./blocktor.sh --start / --remove\n"
exit 1
esac
