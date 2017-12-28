# blocktor
Block all Tor connection from accessing your webserver
Nee ipset:
apt-get install -y ipset

Add to root crontab (sudo crontab -e):
@reboot /path/to/blocktor.sh;
0 0 0 * * * /path/to/blocktor.sh
