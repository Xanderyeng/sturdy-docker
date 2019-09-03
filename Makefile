.PHONY: initial-setup create-certificates add-hosts

initial-setup: provision/initial-setup.sh
	/bin/bash provision/initial-setup.sh

create-certificates: provision/tls-ca.sh
	/bin/bash provision/tls-ca.sh

add-hosts: provision/hosts.sh
	/bin/bash provision/hosts.sh