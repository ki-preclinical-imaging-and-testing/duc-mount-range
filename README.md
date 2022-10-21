# DUC Mount Range

This package is designed to monitor storage usage on a core research facility's 
multimodal workstations. 

By mounting each of the machines on the local /mnt/ drive, this gives the
administrator CLI tools that can quickly summarize storage on multiple
machines and servers.  

It makes the most sense to run these as root, but it doesn't make sense to use
git as root, so the current installation procedure involves cloning to the
`prod` account and then installing so that these can be used as root while
nightly runs are stored in `/home/prod/duc-mount-range/`. Perhaps someone can
chime in with a better way to do this in the future.

## Cronjob

The current implementation runs nightly, and this is a

  crontab -e


## Fish Shell

Add the following blocks of code to your ~/.config/fish/config.fish
Copy fish/duc-mount-range.fish to your root fish conf directory at /root/.config/fish/conf.d/. 

TODO: This could be automated!


## Shell Scripts

Move the following scripts to your ~/.config/fish/ directory

  mount-workstation.sh
  unmount-workstation.sh

Then soft link to your /bin/ using

  link.sh

## Additional instructions

You can produce a shareable report of the ghosts using something like this

  julia julia/duc-ghosts.jl -b /mnt/sonic/C:/Users -p > "/home/patch/sonic-ghosts-$(date +%F).csv"


### Manual installation steps...

Several of these files require changing path variables to ensure it works right
on the machine, but this isn't documented perfectly yet. Just worth keeping in
mind while setting this up. E.g. fish config, bash files, link.sh, etc... note
also that some machines require stdin passwords for sshfs or, for example,
Rowley requires text credentials. The two places this is currently done:

- /home/patch/.cifs/rowley-credentials.dat
- /home/prod/.ssh/{sonic, photon}.pass

The `.pass` files should only be the password string. Ideally you should modify
permissions on these so that only the install account can see them. 

The `.cifs/rowley-credentials.dat` file takes the form

  1 username=patch@WIN
  2 password=[enter real password here without brackets]

Simply enter the correct information here, and you're good to go.
	 
