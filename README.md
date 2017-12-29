# blocktor
## Block all Tor connection from accessing your webserver
> Need ipset:
```
apt-get install -y ipset
```
> Usage
```
chmod +x blocktor.sh
sudo ./blocktor.sh --start
sudo ./blocktor.sh --remove
```
> Add to root crontab (sudo crontab -e):
```
@reboot /path/to/blocktor.sh;
0 0 0 * * * /path/to/blocktor.sh
```
