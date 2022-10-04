#!/bin/bash
home=$( dirname -- "$0" )
archive=$home/archive
ductmp=$home/nightly.db
logtmp=$home/nightly.log
ducarc=$archive/`date +%F_%H-%M-%S`.db
logarc=$archive/`date +%F_%H-%M-%S`.log

echo $home
echo $archive
echo $ductmp
echo $logtmp
echo $ducarc
echo $logarc
exit

_ttmp=`date`
echo 
echo "  Mountpoint Status @ ${_ttmp}"
echo "                      (Before Scan)"
fish -c 'mount-in-range'
fish -c 'data_center_df'
echo
echo 
echo "  Nightly DUC index is starting... "
echo "  ... database will be stored at $ductmp"
echo 
_t0=`date`
echo "  Start: ${_t0}"
echo
time duc index /mnt /home -vpH \
  --exclude=kcore \
  --exclude="Application Data" --exclude="AppData" \
  --exclude="Documents and Settings" --exclude "Local Settings" \
  -d /home/patch/mnt-duc/nightly.db 
_t1=`date`
echo
echo "  End: ${_t1}" 
echo
echo "    Copying .db and .log to $archive ..."
echo "    $ cp --preserve $ductmp $ducarc"
echo "    $ cp --preserve $logtmp $logarc"
time cp --preserve $ductmp $ducarc
time cp --preserve $logtmp $logarc
echo 
_ttmp=`date`
echo "  Mountpoint Status @ ${_ttmp}"
echo "                      (After Scan)"
fish -c 'data_center'
fish -c 'data_center_df'
echo
echo "  Done."