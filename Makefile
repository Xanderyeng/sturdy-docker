.PHONY: all initial-setup create-sites create-certificates create-database remove-sites

default: all

all: initial-setup create-sites create-certificates

initial-setup: provision/initial-setup.sh
	/bin/bash provision/initial-setup.sh

create-sites: provision/create-sites.sh
	/bin/bash provision/create-sites.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh

create-database: provision/create-database.sh
	/bin/bash provision/create-database.sh

remove-sites: provision/remove-sites.sh
	/bin/bash provision/remove-sites.sh