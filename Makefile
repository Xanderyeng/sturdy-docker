.PHONY: initial-setup create-sites create-certificates pull-images remove-sites

initial-setup: provision/initial-setup.sh
	/bin/bash provision/initial-setup.sh

create-sites: provision/create-sites.sh
	/bin/bash provision/create-sites.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh

pull-images:
	docker pull benlumia007/docker-nginx:latest
	docker pull benlumia007/docker-mysql:latest
	docker pull benlumia007/docker-wordpress:7.3-fpm

remove-sites: provision/remove-sites.sh
	/bin/bash provision/remove-sites.sh