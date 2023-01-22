#!/bin/bash

### Variables
TEMP="/tmp/online"
VALUE=$(ip addr show | grep -v LOOPBACK | grep -i global | awk '{print $2}')

###Cheking sudo preveligies
grep $USER /etc/sudoers &> /dev/null
if [[ $? -ne 0 ]]; then
echo "Permission denied. Sorry but You aren't in sudo group"    
sleep 2
exit
fi

###Installing dependencies 
yum --help > /dev/null
if [[ $? -eq 0 ]]; then
  yum install nmap net-tools -y > /dev/null
  else
  apt-get install nmap net-tools -y > /dev/null
fi

### Function displays the IP addresses and symbolic names of all hosts in the current subnet
function scan () { 
  echo "##########################################"          
  echo "ALL hosts in the current subnet"
  echo "##########################################" 
  echo 'Scanning ..............'     
  nmap -sP $VALUE | grep -i for | awk '{print $(NF-1),"\t",$NF}' > $TEMP
  sed -i 's/for/Hostname not spesified/' $TEMP
  cat $TEMP
}
### Fuction displays a list of open system TCP ports
function port () {
  echo "##########################################"          
  echo "List of open TCP ports"
  echo "##########################################"   
  #netstat -antp|grep -i tcp|awk '{print $4}'|sed  's/:/ /g'|awk '{print $NF}'|sort|uniq
  nmap -T4 $VALUE
}

### Function displays help
 function help () {
  if [[ $# -eq 0 ]]; then
  echo "##########################################"       
  echo "You need to choose the key" 
  echo "##########################################"    
  echo -e "--all - This key displays the IP addresses and symbolic names of all hosts in the current subnet
  or\n--target - This key that displays a list of open system TCP ports."
  else
  echo '##########################################'
  echo 'Your key is incorect. Please input --all or --target key'
  echo '##########################################' 
  fi
}

### MAIN
if [[ $1 == "--all" ]]; then
  scan
elif [[ $1 == "--target" ]]; then 
  port
else
  help $*
fi

### Remove temporary files
rm -rf $TEMP

