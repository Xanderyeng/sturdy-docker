.PHONY: all initial-setup create-sites create-certificates remove-sites

default: all

all: initial-setup create-sites create-certificates

initial-setup: provision/init.sh
	/bin/bash provision/init.sh

create-sites: provision/create-sites.sh
	/bin/bash provision/create-sites.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh

remove-sites: provision/remove-sites.sh
	/bin/bash provision/remove-sites.sh