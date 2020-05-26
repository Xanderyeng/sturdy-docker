.PHONY: all docker-setup docker-database docker-dashboard docker-sites docker-resources docker-wordpress

default: all

all: docker-setup docker-database docker-dashboard docker-sites docker-resources docker-wordpress

docker-setup: provision/setup.sh
	/bin/bash provision/setup.sh

docker-dashboard: provision/dashboard.sh
	/bin/bash provision/dashboard.sh

docker-sites: provision/sites.sh
	/bin/bash provision/sites.sh

docker-resources: provision/resources.sh
	/bin/bash provision/resources.sh

docker-wordpress: provision/wordpress.sh
	/bin/bash provision/wordpress.sh

backup-database: provision/backup-database.sh
	/bin/bash provision/backup-database.sh

docker-database: provision/database.sh
	/bin/bash provision/database.sh
