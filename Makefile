.PHONY: all docker-setup docker-dashboard docker-sites docker-resources remove-sites start-server start-sites

default: all

all: docker-setup docker-dashboard docker-sites docker-resources

docker-setup: provision/setup.sh
	/bin/bash provision/setup.sh

docker-dashboard: provision/dashboard.sh
	/bin/bash provision/dashboard.sh

docker-resources: provision/resources.sh
	/bin/bash provision/resources.sh

remove-sites: provision/remove-sites.sh
	/bin/bash provision/remove-sites.sh

start-server: provision/start-server.sh
	/bin/bash provision/start-server.sh

start-sites: provision/start-sites.sh
	/bin/bash provision/start-sites.sh
