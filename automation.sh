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
sudo systemctl start apache2

echo "Checking apache service status"

apachestat=$(systemctl status apache2)
if [[ $apachestat == *"active (running)"* ]];
then
	echo "apache2 is running"
else
	echo "apache2 is not running"
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


