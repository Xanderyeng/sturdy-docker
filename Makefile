.PHONY: create-network initial-setup create-certificates

create-network:
	docker network create --driver=bridge --subnet=172.141.0.0/16 --ip-range=172.141.145.0/24 frontend

initial-setup: provision/initial-setup.sh
	cp config/docker-setup.yml config/docker-custom.yml
	/bin/bash provision/initial-setup.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh