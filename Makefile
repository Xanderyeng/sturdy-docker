.PHONY: all docker-dashboard docker-sites docker-resources

default: all docker-dashboard

all: docker-dashboard docker-sites docker-resources

docker-dashboard: provision/dashboard.sh
	/bin/bash provision/dashboard.sh

docker-sites: provision/setup.sh
	/bin/bash provision/setup.sh

docker-resources: provision/resources.sh
	/bin/bash provision/resources.sh