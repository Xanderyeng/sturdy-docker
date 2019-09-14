.PHONY: all docker-provision

default: all

all: docker-provision

docker-provision: provision/setup.sh
	/bin/bash provision/setup.sh