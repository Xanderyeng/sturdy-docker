.PHONY: all docker-setup docker-restore docker-dashboard docker-sites docker-resources docker-backup docker-services

default: all

all: docker-setup docker-restore docker-dashboard docker-sites docker-resources docker-services

docker-setup: setup.sh
	/bin/bash setup.sh

docker-restore: databases.sh
	/bin/bash databases.sh


docker-dashboard: dashboard.sh
	/bin/bash dashboard.sh

docker-sites: sites.sh
	/bin/bash sites.sh

docker-resources: resources.sh
	/bin/bash resources.sh

docker-services: services.sh
	/bin/bash services.sh

docker-backup: db_backup.sh
	/bin/bash db_backup.sh