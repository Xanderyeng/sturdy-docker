const fs = require( 'fs-extra' );
const replace = require( 'replace-in-file' );
const { exec } = require( 'child_process' );
const isWSL = require( 'is-wsl' );
const shell = require( 'shelljs' );
const yaml = require( 'js-yaml' );
const path = require( `./configure` );
const getConfigPath = path.setConfigPath();
const getSitesPath = path.setSitesPath();
const getCertsPath = path.setCertsPath();
const getGlobalPath = path.setGlobalPath();
const getComposeFile = path.setComposeFile();
const getCustomFile = path.setCusomFile();
const getLogsPath = path.setLogsPath();


// Here, we are going to copy the compose and custom file to the .global
if ( ! fs.existsSync( `${getGlobalPath}/docker-custom.yml` ) ) {
	shell.cp( `-r`, `${getConfigPath}/templates/docker-setup.yml`, `${getGlobalPath}/docker-custom.yml` );
	shell.cp( `-r`, `${getConfigPath}/templates/docker-compose.yml`, `${getGlobalPath}/docker-compose.yml` );
}

// Here, we are going to create an nginx conf file for dashboard
if ( ! fs.existsSync( `${getConfigPath}/nginx/dashboard.conf` ) ) {
	shell.cp( `-r`, `${getConfigPath}/templates/nginx.conf`, `${getConfigPath}/nginx/dashboard.conf` );

	const options = { files: `${getConfigPath}/nginx/dashboard.conf`, from: /{{DOMAIN}}/g, to: `dashboard` };
	replaced = replace.sync( options );

	if ( isWSL ) {
		shell.exec( `wp4docker-hosts set 127.0.0.1 dashboard.test` );
	} else {
		shell.exec( `sudo wp4docker-hosts set 127.0.0.1 dashboard.test` );
	}
}

// Here we are going to create a dashboard folder to host the dashboard's files
if ( ! fs.existsSync( `${getSitesPath}/dashboard/public_html` ) ) {
	shell.mkdir( `-p`, `${getSitesPath}/dashboard/public_html` );
}

// Here, we are going to grab files from GitHub for the dashboard.
if ( ! fs.existsSync( `${getSitesPath}/dashboard/public_html/.git` ) ) {
	exec( `git clone https://github.com/benlumia007/wp-4-docker-dashboard.git ${getSitesPath}/dashboard/public_html` );
} else {
	exec( `git pull`, { cwd: `${getSitesPath}/dashboard/public_html` } );
}

// Here, we are going to create a certs for the dashboard, which also includes the root ca by default.
if ( ! fs.existsSync( `${getCertsPath}/ca/ca.crt` ) ) {
	shell.mkdir( `-p`, `${getCertsPath}/ca` );

	shell.exec( `openssl genrsa -out "${getCertsPath}/ca/ca.key" 4096` );
	shell.exec( `openssl req -x509 -new -nodes -key "${getCertsPath}/ca/ca.key" -sha256 -days 365 -out "${getCertsPath}/ca/ca.crt" -subj "/CN=Docker for WordPress"` );
}

// Here, we are going to create certs for the dashboard.
if ( ! fs.existsSync( `${getCertsPath}/dashboard/dashboard.crt` ) ) {
	shell.mkdir( `-p`, `${getCertsPath}/dashboard` );
	shell.cp( `-r`, `${getConfigPath}/templates/certs.ext`, `${getCertsPath}/dashboard/dashboard.ext` );

	const options = { files: `${getCertsPath}/dashboard/dashboard.ext`, from: /{{DOMAIN}}/g, to: `dashboard` };
	replaced = replace.sync( options );

	shell.exec( `openssl genrsa -out "${getCertsPath}/dashboard/dashboard.key" 4096` );
	shell.exec( `openssl req -new -key "${getCertsPath}/dashboard/dashboard.key" -out "${getCertsPath}/dashboard/dashboard.csr" -subj "/CN=*.dashboard.test"` );
	shell.exec( `openssl x509 -req -in "${getCertsPath}/dashboard/dashboard.csr" -CA "${getCertsPath}/ca/ca.crt" -CAkey "${getCertsPath}/ca/ca.key" -CAcreateserial -out "${getCertsPath}/dashboard/dashboard.crt" -days 365 -sha256 -extfile "${getCertsPath}/dashboard/dashboard.ext"` );
}
