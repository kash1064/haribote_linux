SHELL=/bin/bash

clear:
	-find . -name "*.o*" -exec rm {} \;
	# -find . -name "*.exe" -exec rm {} \;
	-find . -name ".gdb_history" -exec rm {} \;
	-find . -name ".bash_history" -exec rm {} \;
	-find . -name ".cache" -exec rm {} \;
	-find . -name "peda-session-*" -exec rm {} \;
	-find . -name "*.img" -exec rm {} \;
	-find . -name "*.lst" -exec rm {} \;
	-find . -name "*.bin" -exec rm {} \;
	-find ./p2_30daysOS_haribote -name "*.sys" -exec rm {} \;
	-find ./p2_30daysOS_haribote -name "*.hrb" -exec rm {} \;	

day := `date +"%Y_%m_%d"`
m := autopush ${day}
branch := origin master
autopush: ## This is auto push module, need commit message(default=autopush)
	make clear
	git add .
	git commit -m "${m}"
	git push ${branch}

pull:
	git pull ${branch}

force_pull:
	git fetch ${branch}
	git reset --hard origin/master

cache_clear:
	git rm -r --cached .

start_docker:
	sudo /etc/init.d/docker start	