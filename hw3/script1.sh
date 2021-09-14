#!/bin/bash

sudo netstat -tunapl
awk '/firefox/ {print $5}'
cut  -d: -f 1  
sort   
uniq -c  
sort  
tail -n5  
grep -oP '(\d+\.){3}\d+'

while read IP 
    do whois $IP  
    awk -F':' '/^Organization/{print $2}'
    done 