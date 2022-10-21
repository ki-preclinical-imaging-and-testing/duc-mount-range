#!/bin/bash
echo
MOUNTIN_KEYS="rowley emit positron magneto photon sonic"
for _k in $MOUNTIN_KEYS
do
  _mp=/mnt/$_k
  if [ -d $_mp ]
  then
    mountpoint -q $_mp
    if [ "$?" == "0" ]
    then
      echo -e "\t [x]\t $_mp \t is mounted."
    else
      for _i in 1 2 3
      do 
        /bin/mount-workstation $_k
        mountpoint -q $_mp
        if [ "$?" == "0" ]
        then 
          echo -e "\t [x]\t $_mp \t is mounted."
          break
        fi
        if [ "$_i" = "3" ]
        then
          echo -e "\t [ ]\t $_mp \t NOT mounted! Remount manually."
        fi
      done
    fi 
  fi
done
echo
