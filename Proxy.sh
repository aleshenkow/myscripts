#!/bin/bash
echo
echo -e "\e[33mThis script will add record to /etc/nginx/conf.d/custom.conf file\e[0m"
echo
while :
do
echo "Please enter DNS record to listen (without http:// or https://)"
read url
echo "Please enter port"
read port

if [ $port != 443 ] ; then
    echo "server {
       listen $port;
       server_name  $url;
       location / {
               proxy_pass http://$url;
               }
}
" >> /etc/nginx/conf.d/custom.conf
echo "Nginx service will be restarted"
systemctl restart nginx
systemctl status nginx |grep "running" > /dev/null
if [ $? != 0 ]
then
    echo -e "\e[31m[!] Nginx is DOWN\e[0m"
else
    echo -e "\e[92m[!] Nginx is UP\e[0m"
fi
echo "http://$url has been added to proxy server.
Please don't forget to add public DNS record to make this URL be accessible from outside"
echo
elif [ $port = 443 ] ; then
    echo "Enter certificate name (e.g. certificate.crt)"
    read cert
    echo "Enter certificate KEY name (e.g. private.key)"
    read key
    echo "server {
        listen $port;
        server_name $url
        ssl on;
        ssl_certificate /etc/nginx/ssl/$cert;
        ssl_certificate_key /etc/nginx/ssl/$key;
        ssl_verify_client off;
        location / {
               proxy_pass https://$url;
               }
}
     " >> /etc/nginx/conf.d/custom.conf
echo "Nginx service will be restarted"
systemctl status nginx |grep "running" > /dev/null
if [ $? != 0 ]
then
    echo -e "\e[31m[!] Nginx is DOWN\e[0m"
else
    echo -e "\e[92m[!] Nginx is UP\e[0m"
fi
echo "https://$url has been added to proxy server.
Please don't forget to put certificate and key to /etc/nginx/ssl/ folder and add public DNS record to make this URL be accessible from outside"
echo
else echo "Wrong port"
echo

fi

done