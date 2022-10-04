#!/bin/bash
nightlydb=/home/prod/duc-mount-range/nightly.db

if [ -z "$1" ] || [ ! -d "$1" ]
then
  echo $1
  echo "ERROR: Base directory could not be found."
else
  if [ ! -z "$2" ] && [ "$2" == 'csv' ]
  then
    echo "LastMod,Size,Path,User" 
  fi 
  for dir in `ls -d $1/*`
  do
    if [ -d $dir ]
    then
      if [ ! -z "$2" ] && [ "$2" == 'csv' ]
      then
        modat=`stat -c %y $dir | cut -d ' ' -f1`
        dirsize=`duc ls -bD $dir -d $nightlydb | awk '{print $1}'`
        username=`echo $dir | rev | cut -d '/' -f1 | rev`
        printf "%s,%s,%s,%s\n" "$modat" "$dirsize" "$dir" "$username"
      else
        modat=`stat -c %y $dir | cut -d '.' -f1`
        dirsize=`duc ls -D $dir -d $nightlydb | awk '{print $1}'`
        printf "%20s %9s %s \n" "$modat" "$dirsize" "$dir"
      fi
    fi
  done
fi
