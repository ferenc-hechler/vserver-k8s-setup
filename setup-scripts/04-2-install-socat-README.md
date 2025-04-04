```
sudo mkdir -p ~root/bin
sudo cp 04-2-root-crontab-socat-ingress-nginx-ports.sh ~root/bin/initsocat.sh
sudo chown root:root ~root/bin/initsocat.sh
sudo chmod 700 ~root/bin/initsocat.sh
sudo /bin/sh -c "( crontab -l ; echo \"1,11,21,31,41,51 * * * *   /root/bin/initsocat.sh\") | crontab -"
```