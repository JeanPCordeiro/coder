# Coder on Kubernetes
Kubernetes manifests to install Coder

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/from-referrer/)

First, modify Makefile.vars to apply to your environment :
```bash
export MASTER1 ?= <your k3s cluster server ip or fqdn name> 
export DOMAIN ?= <your domain name>
```

Then, set your environment :
```bash
make ssh_set
make ssh_test
make k3s_config
```

Then, install Coder,
the url for your WB will be https://coder.${DOMAIN}

the url for your Server will be https://kie-server.drools.${DOMAIN}
```bash
make k3s_coder_install 
```

to uninstall Coder
```bash
make k3s_coder_uninstall 
```