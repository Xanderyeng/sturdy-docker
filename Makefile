.PHONY: all docker-setup docker-dashboard docker-sites docker-resources docker-server docker-wordpress

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

docker-server: provision/server.sh
	/bin/bash provision/server.sh

docker-wordpress: provision/wordpress.sh
	/bin/bash provision/wordpress.sh
