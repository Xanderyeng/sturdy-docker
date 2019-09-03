.PHONY: initial-setup create-certificates pull-images

initial-setup: provision/initial-setup.sh
	/bin/bash provision/initial-setup.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh

pull-images:
	docker pull benlumia007/docker-nginx
	docker pull benlumia007/docker-mysql
	docker pull benlumia007/docker-wordpress