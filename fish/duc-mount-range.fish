# DUC Mount Range fish functions
# Add this to your own config.fish file from head with
# ~> `cat fish/config.fish >> ~/.config/fish/config.fish`
# For other computer suites, modify the aliases below:
#
set CIFS_CRED '/home/prod/.cifs'

set ROWLEY_KEY 'rowley'
set ROWLEY_HOME "/mnt/$ROWLEY_KEY"
alias base-rowley="echo $ROWLEY_HOME"
alias base-cd-rowley="cd $ROWLEY_HOME; echo '> cd $ROWLEY_HOME'"
alias base-ls-rowley="ls $ROWLEY_HOME"
#alias mount-rowley="mount -t cifs -o vers=3,credentials=$CIFS_CRED/rowley-credentials.dat //rowley.mit.edu/atwai $ROWLEY_HOME"
alias mount-rowley="/bin/mount-workstation rowley"
alias mounted-rowley='is_mounted $ROWLEY_HOME'
alias unmount-rowley="umount $ROWLEY_HOME"
set MOUNTIN_KEYS $ROWLEY_KEY

set JULIASERV_KEY 'juliaserver'
set JULIASERV_HOME "/mnt/$JULIASERV_KEY"
alias base-juliaserver="echo $JULIASERV_HOME"
alias base-cd-juliaserver="cd $JULIASERV_HOME; echo '> cd $JULIASERV_HOME'"
alias base-ls-juliaserver="ls $JULIASERV_HOME"
alias mount-juliaserver='/bin/mount-workstation juliaserver'
alias unmount-juliaserver='fusermount -u $JULIASERV_HOME'
alias mounted-juliaserver='is_mounted $JULIASERV_HOME'
set MOUNTIN_KEYS $JULIASERV_KEY $MOUNTIN_KEYS

set SONIC_KEY 'sonic'
set SONIC_HOME "/mnt/$SONIC_KEY"
alias base-sonic="echo $SONIC_HOME"
alias base-cd-sonic="cd $SONIC_HOME; echo '> cd $SONIC_HOME'"
alias base-ls-sonic="ls $SONIC_HOME"
alias mount-sonic='/bin/mount-workstation sonic'
alias mounted-sonic='is_mounted $SONIC_HOME'
alias unmount-sonic='fusermount -u $SONIC_HOME'
set MOUNTIN_KEYS $SONIC_KEY $MOUNTIN_KEYS

set PHOTON_KEY 'photon'
set PHOTON_HOME "/mnt/$PHOTON_KEY"
alias base-photon="echo $PHOTON_HOME"
alias base-cd-photon="cd $PHOTON_HOME; echo '> cd $PHOTON_HOME'"
alias base-ls-photon="ls $PHOTON_HOME"
alias mount-photon='/bin/mount-workstation photon'
alias mounted-photon='is_mounted $PHOTON_HOME'
alias unmount-photon='fusermount -u $PHOTON_HOME'
set MOUNTIN_KEYS $PHOTON_KEY $MOUNTIN_KEYS

set EMIT_KEY 'emit'
set EMIT_HOME "/mnt/$EMIT_KEY"
alias base-emit="echo $EMIT_HOME"
alias base-cd-emit="cd $EMIT_HOME; echo '> cd $EMIT_HOME'"
alias base-ls-emit="ls $EMIT_HOME"
alias mount-emit='sshfs patch@emit:/ $EMIT_HOME'
alias mount-emit='/bin/mount-workstation emit'
alias mounted-emit='is_mounted $EMIT_HOME'
alias unmount-emit='fusermount -u $EMIT_HOME'
set MOUNTIN_KEYS $EMIT_KEY $MOUNTIN_KEYS

set POSITRON_KEY 'positron'
set POSITRON_HOME "/mnt/$POSITRON_KEY"
alias base-positron="echo $POSITRON_HOME"
alias base-cd-positron="cd $POSITRON_HOME; echo '> cd $POSITRON_HOME'"
alias base-ls-positron="ls $POSITRON_HOME"
alias mount-positron='/bin/mount-workstation positron'
alias mounted-positron='is_mounted $POSITRON_HOME'
alias unmount-positron='fusermount -u $POSITRON_HOME'
set MOUNTIN_KEYS $POSITRON_KEY $MOUNTIN_KEYS

set MAGNETO_KEY 'magneto'
set MAGNETO_HOME "/mnt/$MAGNETO_KEY"
alias base-magneto="echo $MAGNETO_HOME"
alias base-cd-magneto="cd $MAGNETO_HOME; echo '> cd $MAGNETO_HOME'"
alias base-ls-magneto="ls $MAGNETO_HOME"
alias mount-magneto='/bin/mount-workstation magneto'
alias mounted-magneto='is_mounted $MAGNETO_HOME'
alias unmount-magneto='fusermount -u $MAGNETO_HOME'
set MOUNTIN_KEYS $MAGNETO_KEY $MOUNTIN_KEYS

function df-mount-range
  set OSMOUNTPTS /mnt/juliaserver /mnt/sonic /mnt/photon /mnt/positron /mnt/magneto /mnt/emit
  set DATAMOUNTPTS /mnt/rowley /mnt/data /mnt/sonic/D: /mnt/photon/X: /mnt/emit/Volumes/Backup\ HDD/ /mnt/emit/Volumes/CFTVolume1/ /mnt/emit/Volumes/CFTVolume2/
  echo
  df -h $OSMOUNTPTS --total | awk '{printf "%7s %7s %7s %7s    %-17s %29s\n", $5, $4, $3, $2, $6, $1}' | head -n 1
  echo
  echo "   OS Usage"
  df -h $OSMOUNTPTS --total | awk '{printf "%7s %7s %7s %7s    %-17s %29s\n", $5, $4, $3, $2, $6, $1}' | head -n -1 | tail -n+2
  echo
  df -h $OSMOUNTPTS --total | awk '{printf "%7s %7s %7s %7s    %-17s %29s\n", $5, $4, $3, $2, $6, "Total OS"}' | tail -n 1
  echo
  echo "   Storage Usage"
  df -h $DATAMOUNTPTS --total | awk '{printf "%7s %7s %7s %7s    %-17s %29s\n", $5, $4, $3, $2, $6, $1}' | head -n -1 | tail -n+2
  echo
  df -h $DATAMOUNTPTS --total | awk '{printf "%7s %7s %7s %7s    %-17s %29s\n", $5, $4, $3, $2, $6, "Total Storage"}' | tail -n 1
  echo
  echo "   Combined Usage"
  df -h $OSMOUNTPTS $DATAMOUNTPTS --total | awk '{printf "%7s %7s %7s %7s    %-17s %29s\n", $5, $4, $3, $2, $6, "Total Combined"}' | tail -n 1
  echo
end

function is_mounted -d "Tests mountpoint to see if mounted"
  command mountpoint -q $argv
  if test "$status" = "0" 
    return 0
  else
    return 1
  end
end

function unmount-range -d "Unmount all of the workstations"
  for _k in $MOUNTIN_KEYS
    set _mp /mnt/$_k
    is_mounted $_mp 
    if test "$status" = "0"
      /bin/unmount-workstation $_k
    end
  end
end

function mount-range -d "Tests and refreshes all workstation and server mountpoints"
  /bin/mount-range
end

set NIGHTLYDUC_HOME /home/patch/duc-mount-range
function duc-mount -d "Wrapper on standard duc command that points to nightly.db"
  duc $argv[1] -d $NIGHTLYDUC_HOME/nightly.db $argv[2]  
end


function generate-ghost-reports -d "Generate reports on all workstation ghosts"
  echo "Producing Sonic Ghost Report..."
  julia $NIGHTLYDUC_HOME/julia/duc-ghosts.jl -b /mnt/sonic/C:/Users -p > "/home/patch/ghosts-sonic-$(date +%F).csv"
  echo "Producing Photon Ghost Report..."
  julia $NIGHTLYDUC_HOME/julia/duc-ghosts.jl -b /mnt/photon/C:/Users -p > "/home/patch/ghosts-photon-$(date +%F).csv"
  echo "Producing Magneto Ghost Report..."
  julia $NIGHTLYDUC_HOME/julia/duc-ghosts.jl -b /mnt/magneto/Users -p > "/home/patch/ghosts-magneto-$(date +%F).csv"
  echo "Producing Positron Ghost Report..."
  julia $NIGHTLYDUC_HOME/julia/duc-ghosts.jl -b /mnt/positron/Users -p > "/home/patch/ghosts-positron-$(date +%F).csv"
  echo "Producing Rowley Ghost Report..."
  julia $NIGHTLYDUC_HOME/julia/duc-ghosts.jl -b /mnt/rowley -p > "/home/patch/ghosts-rowley-$(date +%F).csv"
  ssconvert --merge-to="/home/patch/Dropbox (MIT)/AIPT/Computation/ghost-report-$(date +%F).xlsx" /home/patch/ghosts*$(date +%F).csv
  chown patch:patch "/home/patch/Dropbox (MIT)/AIPT/Computation/ghost-report-$(date +%F).xlsx" 
  chown patch:patch /home/patch/ghosts*$(date +%F).csv
  echo "Reports printed to Dropbox (MIT)/AIPT/Computation/ghost-report-$(date +%F).xlsx"
  echo
end

function duc-list-dir-modsize -d "Generic function to list directories scanned in DUC alongside their size and last modification time\nUsage: duc-list-dir-modsize path-to-base-dir path-to-duc-db"
  if set -q argv[3]
    if [ $argv[3] = 'csv' ]
      echo "LastMod,Size,Path,User" 
    end
  end
  for dir in (bash -c "ls -d $argv[1]/*")
    if test -d $dir
      if set -q argv[3]
        if [ $argv[3] = 'csv' ]
          set modat (stat -c %y $dir | cut -d ' ' -f1)
          set dirsize (duc ls -bD $dir -d $argv[2] | awk '{print $1}')
          set username (echo $dir | rev | cut -d '/' -f1 | rev)
          printf "%s,%s,%s,%s\n" $modat $dirsize $dir $username
        end
      else
        set modat (stat -c %y $dir | cut -d '.' -f1)
        set dirsize (duc ls -D $dir -d $argv[2] | awk '{print $1}')
        printf "%20s %9s %s\n" $modat $dirsize $dir
      end
    end
  end
end

function duc-list-sonic-users -d "Function to identify file size and last
modification time for all users directories on Sonic (option: arg1=csv)" 
  duc-list-dir-modsize /mnt/sonic/C:/Users $NIGHTLYDUC_HOME/nightly.db $argv[1]
end

function duc-list-photon-users -d "Function to identify file size and last
modification time for all users directories on Photon (option: arg1=csv)" 
  duc-list-dir-modsize /mnt/photon/C:/Users $NIGHTLYDUC_HOME/nightly.db $argv[1]
end

function find_network_addr -d "Find IP address and info about network machine,
e.g. SONIC, PHOTON, MAGNETO, ..."
  for _i in $argv
    command nmap -sn 10.159.0.1/24 | grep -A1 $_i
  end
end

function find_network_ip -d "Find IP address of network machine, e.g. SONIC,
PHOTON, MAGNETO, ..."
  echo
  for _i in $argv
    set _k $(find_network_addr $_i | head -1 | cut -d ' ' -f5)
    set _v $(find_network_addr $_i | head -1 | cut -d '(' -f2 | cut -d ')' -f1)
    echo -e "\t $_v \t $_k"
  end
  echo 
end

function list_network_ip --wraps find_network_ip -d "Finds network addresses
of workstations with static hostnames and prints in simple 2-column format"
  find_network_ip KI-SONIC KI-MAGNETO JULIASERVER KI-PHOTON KI-POSITRON ROWLEY
end
