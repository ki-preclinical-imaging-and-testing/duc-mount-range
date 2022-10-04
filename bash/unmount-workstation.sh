#!/bin/bash
if [ "$1" == "sonic" ] || [ "$1" == "photon" ] || [ "$1" == "magneto" ] ||
  [ "$1" == "positron" ] || [ "$1" == "emit" ] || [ "$1" == "juliaserver" ]
then
  echo "... unmounting $1"
  fusermount -u /mnt/$1

elif [ "$1" == "rowley" ]
then
  echo "... unmounting $1"
  umount /mnt/$1
else
  echo "ERROR: Could not determine identity of machine to unmount"
fi
