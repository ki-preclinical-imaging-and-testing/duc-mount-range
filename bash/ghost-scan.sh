#!/bin/bash
i=$2
days=$(( ( $(date '+%s') - $(date -d "${i} months ago" '+%s') ) / 86400 ))
find $1 -maxdepth 1 -type d -mtime +$days
