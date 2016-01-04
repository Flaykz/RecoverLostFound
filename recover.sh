#!/bin/sh
log="/var/log/recover.log"
sudo file ../lost+found/* > listFileDir
if [ ! -f "listFileDir" ];then
    exit 0;
fi
sudo sed 's/://' listFileDir > listFileDir2
while read ligne
do
set $(echo "$ligne")
path=$(eval echo "$1")
type=$(eval echo "$2")

if [ ! -d "$type" ];then
  sudo mkdir "$type" >/dev/null 2>&1
fi
if [ -d "$path" ];then
  sudo echo "mv -Rf $path $type/" >> "$log"
  sudo mv "$path" "$type/"
else
  if [ -f "$path" ];then
    name=`basename "$path"`
    sudo echo " mv $path $type/$name.$type" >> "$log"
    sudo mv "$path" "$type/$name.$type"
  fi
fi

sudo chmod 777 -R "$type"
done < listFileDir2
rm listFileDir
rm listFileDir2
