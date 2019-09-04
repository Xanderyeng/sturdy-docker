.PHONY: initial-setup create-sites create-certificates pull-images

initial-setup: provision/initial-setup

create-sites: provision/create-sites.sh
	/bin/bash provision/create-sites.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh

pull-images:
	docker pull benlumia007/docker-nginx
	docker pull benlumia007/docker-mysql
	docker pull benlumia007/docker-wordpress