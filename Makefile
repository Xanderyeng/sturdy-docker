.PHONY: create-network

create-network:
	docker network create --driver=bridge --subnet=172.141.0.0/16 --ip-range=172.141.145.0/24 frontend