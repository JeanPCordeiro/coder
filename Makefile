ifndef VERBOSE
.SILENT:
endif

include Makefile.vars

info:
	printf "\033c"
	echo 
	echo 
	echo " \033[0;32mInstall Coder on K3S\033[0m"
	echo 
	echo "Usage" 
	echo "	make \033[0;33mssh_set\033[0m"
	echo "	make \033[0;33mssh_test\033[0m"
	echo "	make \033[0;33mk3s_config\033[0m"
	echo

ssh_set:
	echo 'StrictHostKeyChecking no' > ~/.ssh/config
	rm -f ~/.ssh/known_hosts
	rm -f ~/.ssh/id_rsa*
	ls ~/.ssh/
	ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
	ssh-copy-id root@${MASTER1}

ssh_test:
	ssh root@${MASTER1} uptime

k3s_config:
	rm -fr ~/.kube
	mkdir ~/.kube
	scp root@${MASTER1}:/etc/rancher/k3s/k3s.yaml ~/.kube/config
	sudo sed -i 's/127.0.0.1/${MASTER1}/g'  ~/.kube/config
	kubectl get nodes -o=wide

