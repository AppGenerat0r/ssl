#!/bin/bash
  git config --global user.email "git@sleepy.host"
  eval `ssh-agent -s`
for f in /var/www/*; do
    if [ -d ${f} ]; then
        # Will not run if no directories are available
	
   	 
        cd "$f";
	 $(ssh-add /home/auth; git add * && git commit -m "Site Editor Update")
	 $(ssh-add /home/auth; git add * && git pull)
	  $(ssh-add /home/auth; git add * && git push)
	git pull
	git push
	chown www-data -R "$f"
	chmod 755 -R "$f/*"
    fi
done
ssh-agent -k
