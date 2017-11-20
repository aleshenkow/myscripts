#!/bin/bash
yum install epel-release -y
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
yum install nrpe nagios-plugins-users nagios-plugins-load nagios-plugins-swap nagios-plugins-disk nagios-plugins-procs -y
#copy plugins from nagios server
echo -e "\e[92mPlease enter Nagios root password\e[0m"
sudo scp root@nagios.godeltech.com:/usr/local/nagios/libexec/\{check_init_service,check_mem\} /usr/lib64/nagios/plugins/

echo    "
command[users]=/usr/lib64/nagios/plugins/check_users -w 5 -c 10
command[load]=/usr/lib64/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
command[check_load]=/usr/lib64/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
command[swap]=/usr/lib64/nagios/plugins/check_swap -w 20% -c 10%
command[root_disk]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p / -m
command[usr_disk]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p /usr -m
command[var_disk]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p /var -m
command[zombie_procs]=/usr/lib64/nagios/plugins/check_procs -w 5 -c 10 -s Z
command[total_procs]=/usr/lib64/nagios/plugins/check_procs -w 190 -c 200
command[proc_named]=/usr/lib64/nagios/plugins/check_procs -w 1: -c 1:2 -C named
command[proc_crond]=/usr/lib64/nagios/plugins/check_procs -w 1: -c 1:5 -C crond
command[proc_syslogd]=/usr/lib64/nagios/plugins/check_procs -w 1: -c 1:2 -C syslog-ng
command[proc_rsyslogd]=/usr/lib64/nagios/plugins/check_procs -w 1: -c 1:2 -C rsyslogd
command[check_service_mem]=/usr/lib64/nagios/plugins/check_mem
command[check_service_postfix]=/usr/lib64/nagios/plugins/check_init_service example
" >> /etc/nrpe.d/op5_commands.cfg
sed -i '105s/\(.*\)/\1,'",192.168.8.241"'/' /etc/nagios/nrpe.cfg

systemctl restart nrpe
systemctl enable nrpe

echo "All done
Please run df -h to define root drive and change /etc/nagios/nrpe.cfg"