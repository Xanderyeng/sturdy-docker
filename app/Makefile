.PHONY: all docker-setup docker-restore docker-dashboard docker-sites docker-resources docker-backup

default: all

all: docker-setup docker-restore docker-dashboard docker-sites docker-resources docker-backup

docker-setup: provision/setup.sh
	/bin/bash provision/setup.sh

docker-restore: provision/restore.sh
	/bin/bash provision/restore.sh

docker-dashboard: provision/dashboard.sh
	/bin/bash provision/dashboard.sh

docker-sites: provision/sites.sh
	/bin/bash provision/sites.sh

docker-resources: provision/resources.sh
	/bin/bash provision/resources.sh

docker-backup: provision/backup.sh
	/bin/bash provision/backup.sh
