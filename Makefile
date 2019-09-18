.PHONY: all docker-setup docker-dashboard docker-sites docker-resources docker-wordpress docker-server docker-sites

default: all

all: docker-setup docker-dashboard docker-sites docker-resources

docker-setup: provision/setup.sh
	/bin/bash provision/setup.sh

docker-dashboard: provision/dashboard.sh
	/bin/bash provision/dashboard.sh

docker-sites: provision/sites.sh
	/bin/bash provision/sites.sh

docker-resources: provision/resources.sh
	/bin/bash provision/resources.sh

docker-server: provision/docker-server.sh
	/bin/bash provision/docker-server.sh

docker-sites: provision/docker-sites.sh
	/bin/bash provision/docker-sites.sh

docker-wordpress: provision/docker-wordpress.sh
	/bin/bash provision/docker-wordpress.sh