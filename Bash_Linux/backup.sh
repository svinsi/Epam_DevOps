#!/bin/bash

###Vareabiles
timestamp=$(date +%F_%T)
DEST="$2"
SOURSE="$1"
LOG="/var/log/backLog"

###Installing cron Fedora
yum --help &>>/dev/null
if [[ $? -eq 0 ]]; then
  yum install cronie -y > /dev/null
  if [[ $? -eq 0 ]]; then
    echo "###########################################"
    echo "Dependencies installed succssefull"
    echo "###########################################"
  fi
  ###Adding cronjob Fedora and start cron service 
  cat /var/spool/cron/$USER | grep $0 > /dev/null
    if [[ $? -eq 1 ]]; then
      echo "* * * * * $0 $SOURSE $DEST" >> /var/spool/cron/"$USER"
        if [[ $? -eq 0 ]]; then
          echo "###########################################"
          echo "Job added succssefull"
          echo "###########################################"
        else 
          echo "Access denieded"
          exit  
        fi 
      sudo systemctl enable crond
      sudo systemctl start crond
        if [[ $? -eq 0 ]]; then
          echo "###########################################"
          echo "Service started succssefull"
          echo "###########################################"
        else 
          echo "Some error with servise cron. You should check log"
        fi    
    fi 
else
###Installing cron UBUNTU
  sudo apt-get install cron > /dev/null
  if [[ $? -eq 0 ]]; then
    echo "###########################################"
    echo "Dependencies installed succssefull"
    echo "###########################################"
  fi
  ###Adding cronjob UBUNTU and start cron services 
  cat /var/spool/cron/crontabs/$USER | grep $0
    if [[ $? -eq 1 ]]; then
      echo "* * * * * $0 $SOURSE $DEST" > /var/spool/cron/crontabs/"$USER"
       if [[ $? -eq 0 ]]; then
        echo "###########################################"
        echo "Job added succssefull"
        echo "###########################################" 
       else 
        echo "Access denieded"
       fi 
      sudo service cron restart
    fi
fi
###Checking arguments
if [ -z "$1" ] || [ -z "$2" ]; then
	echo "You have failed to pass a parameter."
	echo "Reminder that all required files will be copied to $DEST."
	echo "USAGE: ./backup.sh LOGFILE var/log/backLog"
	exit 255;
fi
### Adding new files to the backup
for file in "$SOURSE"/*; do
	if [[ ! -e "$DEST/${file##*/}" ]]; then
		echo "Adding new $file at $timestamp" >> $LOG	
		sudo cp -R $file $DEST
    elif [[ $file -nt "$DEST/${file##*/}" ]]; then
    	echo "Updating existed $file at $timestamp" >> $LOG
    	sudo cp -u $file $DEST
    fi
done
### Removing files from the backup
for file in $DEST/*; do
	if [[ ! -e "$SOURSE/${file##*/}" && -e $file ]]; then
   	echo "Remove files $file at $timestamp" >> $LOG
   	rm -rf $file
	fi
done

cat "$LOG"
