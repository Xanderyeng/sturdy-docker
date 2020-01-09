.PHONY: all docker-setup import-database docker-dashboard docker-sites docker-resources docker-wordpress

default: all

all: docker-setup import-database docker-dashboard docker-sites docker-resources

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

import-database: provision/import-database.sh
	/bin/bash provision/import-database.sh
