#!/bin/bash
home=$( dirname -- "$0" )
idf=/home/patch/.ssh/ed3g-np 
sai=15
sacm=10
if [ "$1" == "sonic" ]
then
  echo "... mounting $1"
  sshfs \
    -o password_stdin,reconnect,ServerAliveInterval=$sai,ServerAliveCountMax=$sacm \
    patch@ki-sonic.mit.edu:/ /mnt/sonic <<< `cat $home/sonic.pass`

elif [ "$1" == "photon" ]
then
  echo "... mounting $1"
  sshfs \
    -o password_stdin,reconnect,ServerAliveInterval=$sai,ServerAliveCountMax=$sacm \
    patch@ki-photon.mit.edu:/ /mnt/photon <<< `cat $home/photon.pass`

elif [ "$1" == "magneto" ]
then
  echo "... mounting $1"
  sshfs -o IdentityFile=${idf},reconnect,ServerAliveInterval=$sai,ServerAliveCountMax=$sacm patch@ki-magneto.mit.edu:/ /mnt/magneto

elif [ "$1" == "positron" ]
then
  echo "... mounting $1"
  sshfs \
    -o IdentityFile=${idf},reconnect,ServerAliveInterval=${sai},ServerAliveCountMax=${sacm} \
    patch@ki-positron.mit.edu:/ /mnt/positron

elif [ "$1" == "emit" ]
then
  echo "... mounting $1"
  sshfs \
    -o IdentityFile=${idf},reconnect,ServerAliveInterval=${sai},ServerAliveCountMax=${sacm} \
    patch@10.159.5.137:/ /mnt/emit

elif [ "$1" == "juliaserver" ]
then
  echo "... mounting $1"
  sshfs \
    -o IdentityFile=${idf},reconnect,ServerAliveInterval=${sai},ServerAliveCountMax=${sacm} \
    patch@juliaserver.mit.edu:/ /mnt/juliaserver

elif [ "$1" == "rowley" ]
then
  echo "... mounting $1"
  mount -t cifs \
    -o vers=3,credentials=/home/patch/.cifs/rowley-credentials.dat \
    //rowley.mit.edu/atwai /mnt/rowley

else
  echo "ERROR: Could not determine identity of machine to mount"
fi
