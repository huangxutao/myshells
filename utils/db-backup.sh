#!/bin/bash

dbName="note_life"

# 1
echo -n "> 请输入 mongo host(default to 127.0.0.1): "

read mongoHost

if [[ $mongoHost == "" ]]; then
  mongoHost="127.0.0.1"
fi



# 2
echo -n "> 请输入 mongo port(default to 27017): "

read mongoPort

if [[ $mongoPort == "" ]]; then
  mongoPort="27017"
fi



# 3
echo -n "> 请输入 db name(default to note_life): "

read dbName

if [[ $dbName == "" ]]; then
  dbName="note_life"
fi


echo "> mongodump -h $mongoHost:$mongoPort -d $dbName -o ./"

mongodump -h $mongoHost:$mongoPort -d $dbName -o ./

echo "scp -r ./$dbName root@140.82.9.207:/home"

scp -r ./$dbName root@140.82.9.207:/home