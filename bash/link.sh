#!/bin/bash
sdir=$( dirname -- $0 )
for _f in $(ls $sdir/*.sh)
do
  _fstr=$(echo $_f | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)
  if [ "$_fstr" == "link.sh" ]
  then
    continue
  else
    _flnk=/bin/$_fstr
    echo "  $ ln -s $_f $_flnk" 
    ln -s $_f $_flnk
  fi
  echo
done
