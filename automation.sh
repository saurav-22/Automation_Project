#!/bin/bash

# Specify variable here
s3_bucket=upgrad-saurav
myname=saurav
timestamp=$(date '+%d%m%Y-%H%M%S')

#Updating all packages
sudo apt-get update -y

#Check if apache2 is installed or not
if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo "apache2 not installed, installing now"
	sudo apt-get install apache2 -y
else
	echo "apache2 already installed"
fi

sleep 1
sudo systemctl daemon-reload

echo "Checking apache service status"

apachestat=$(systemctl status apache2)
if [[ $apachestat == *"active (running)"* ]];
then
	echo "apache2 is running"
else
	sudo systemctl start apache2
fi

if [[ $apachestat == *"disabled"* ]];
then
	sudo systemctl enable apache2
fi
sleep 1
echo "Creating archive of log files in /tmp directory"
tar -cvf /tmp/$myname-httpd-logs-$timestamp.tar /var/log/apache2/*.log

#Copy archive to s3 bucket
aws s3 cp /tmp/$myname-httpd-logs-$timestamp.tar s3://$s3_bucket/$myname-httpd-logs-$timestamp.tar

cron_file=/etc/cron.d/automation
if [ -f "$cron_file" ];
then
	echo "File found, checking cron job"
	str=$(cat /etc/cron.d/automation)
if [[ ! $str == *"automation.sh"* ]]; then
	echo "Cron job is not scheduled."
	echo "Scheduling cron job now"
	sudo echo "0 0 * * * root /Automation_Project/automation.sh" > /etc/cron.d/automation
	sudo chmod 600 /etc/cron.d/automation
else
	echo "Cron job found"

fi
else
	echo "File not found"
	echo "Creating crontab file to schedule automation.sh script"
	touch /etc/cron.d/automation
	sudo echo "0 0 * * * root /Automation_Project/automation.sh" > /etc/cron.d/automation
	sudo chmod 600 /etc/cron.d/automation
fi

if [ ! -f /var/www/html/inventory.html ];
then
        echo "inventory.html does not exist. Creating a new file."
        sudo touch /var/www/html/inventory.html
        echo "<html><head><h2>Log Type &nbsp; Date Created &nbsp; Type &nbsp; Size</h2></head></html>" >> /var/www/html/inventory.html
fi
log_file=$(ls /tmp -Artsh | tail -1)
log_type=${log_file:12:10}
date=${log_file:23:15}
type="tar"
size=${log_file:1:3}
sudo echo "<html><body><h3>$log_type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $date &nbsp;&nbsp;&nbsp; $type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $size<br></h3></body></html>" >> /var/www/html/inventory.html
