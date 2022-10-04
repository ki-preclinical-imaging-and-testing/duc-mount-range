# DUC Mount Range

This package is designed to monitor storage usage on a core research facility's 
multimodal workstations. 

By mounting each of the machines on the local /mnt/ drive, this gives the
administrator CLI tools that can quickly summarize storage on multiple
machines and servers.  

## Cronjob

The current implementation runs nightly, and this is a

  crontab -e


## Fish Shell

Add the following blocks of code to your ~/.config/fish/config.fish

  TODO: Add the script here!

## Shell Scripts

Move the following scripts to your ~/.config/fish/ directory

  mount-workstation.sh
  unmount-workstation.sh

Then soft link to your /bin/ using the following:

  ln -s <> <>

## Additional instructions


