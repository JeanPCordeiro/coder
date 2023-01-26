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

coder_installcli:
	curl -L https://coder.com/install.sh | sh -s -- 

coder_install:
	kubectl create namespace coder
	kubectl create namespace coder-workspaces
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install coder-db bitnami/postgresql \
    	--namespace coder \
    	--set auth.username=coder \
    	--set auth.password=coder \
    	--set auth.database=coder \
    	--set persistence.size=10Gi
	helm repo add coder-v2 https://helm.coder.com/v2
	kubectl create secret generic coder-db-url -n coder \
   		--from-literal=url="postgres://coder:coder@coder-db-postgresql.coder.svc.cluster.local:5432/coder?sslmode=disable"
#	kubectl -n coder create secret generic coder-secret-github --from-literal=client-secret="fa04b42e58c37287d5bbfbee2a61c2840c603eaa"
#	kubectl -n coder create secret generic coder-client-github --from-literal=client-id="5feae84c374175bc4670"
	helm install coder coder-v2/coder \
    	--namespace coder \
    	--values values.yaml
	cat coder.yaml | envsubst '$${DOMAIN}' | kubectl apply -f -
	kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=coder:coder

