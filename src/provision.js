#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( "./configure" );
const getRootPath = path.setRootPath();
const getCertsPath = path.setCertsPath();
const getConfigPath = path.setConfigPath();
const getDatabasesPath = path.setDatabasesPath();
const getLogsPath = path.setLogsPath();
const getSitesPath = path.setSitesPath();
const getSrcPath = path.setSrcPath();
const isWSL = require( "is-wsl" );

// Here, we will be using the require the js-yaml and fs file and read the .global/docker-custom.yml
const fs = require( "fs-extra" );
const yaml = require( "js-yaml" );
const replace = require( "replace-in-file" );
const shell = require( "shelljs" );
const configuredHosts = require( "./hosts" );
const getComposeFile = path.setComposeFile();
const getCustomFile = path.setCusomFile();
const { execSync } = require( 'child_process' );
const { exec } = require( 'child_process' );

const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );

// Here we are going to setup the actual sites
const domains = config.sites.domain;
const provision = config.sites.provision;

if ( provision == true ) {
    for ( const domain of domains ) {
        if ( ! fs.existsSync( `${getConfigPath}/nginx/${domain}.conf` ) ) {
			fs.copy( `${getConfigPath}/templates/nginx.conf`, `${getConfigPath}/nginx/${domain}.conf`, error => {
				if ( error ) {
					throw error;
				} else {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /{{DOMAIN}}/g, to: `${domain}` };
					replaced = replace.sync( options )

					if ( isWSL ) {
						configuredHosts.set('127.0.0.1', `${domain}.test`, function (err) {
							if (err) {
							  console.error(err)
							} else {
							  console.log('set /etc/hosts successfully!')
							}
						});
					} else {
						exec( `sudo d4w-hosts set 127.0.0.1 ${domain}.test` );
					}
				}
			} );
		}

        if ( ! fs.existsSync( `${getSitesPath}/${domain}/public_html` ) ) {
			fs.mkdir( `${getSitesPath}/${domain}/public_html`, { recursive: true }, error => {
				if ( error ) {
					throw error;
				} else {
					if ( ! fs.existsSync( `${getSitesPath}/${domain}/public_html/wp-config.php` ) ) {
						const dir = `/srv/www/${domain}/public_html`;

						execSync( `docker-compose -f ${getComposeFile} exec -T mysql mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"` );
						execSync( `docker-compose -f ${getComposeFile} exec -T mysql mysql -u root -e "CREATE USER IF NOT EXISTS 'nginx'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'nginx';"` );
						execSync( `docker-compose -f ${getComposeFile} exec -T mysql mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'nginx'@'%' WITH GRANT OPTION;"` );
						execSync( `docker-compose -f ${getComposeFile} exec -T mysql mysql -u root -e "FLUSH PRIVILEGES;"` );

						execSync( `docker-compose -f ${getComposeFile} exec -T nginx wp core download --path=${dir}` );
						execSync( `docker-compose -f ${getComposeFile} exec -T nginx wp config create --dbhost=mysql --dbname=${domain} --dbuser=nginx --dbpass=nginx --path=${dir}` );
						execSync( `docker-compose -f ${getComposeFile} exec -T nginx wp core install  --url="https://${domain}.test" --title="${domain}.test" --admin_user=admin --admin_password=password --admin_email="admin@${domain}.test" --skip-email --quiet --path=${dir}` );
						execSync( `docker-compose -f ${getComposeFile} exec -T nginx wp plugin delete akismet --path=${dir}` );
						execSync( `docker-compose -f ${getComposeFile} exec -T nginx wp plugin delete hello --path=${dir}` );
						execSync( `docker-compose -f ${getComposeFile} exec -T nginx wp config shuffle-salts --path=${dir}` );
					}
				}
			} );
		}

		// Here, we are going to create certs for the ${domain}.
		if ( ! fs.existsSync( `${getCertsPath}/${domain}/${domain}.crt` ) ) {
			fs.mkdir( `${getCertsPath}/${domain}/`, { recursive: true }, error => {
				if ( error ) {
					throw error;
				} else {
					fs.copy( `${getConfigPath}/templates/certs.ext`, `${getCertsPath}/${domain}/${domain}.ext`, error => {
						if ( error ) {
							throw error;
						} else {
							const options = { files: `${getCertsPath}/${domain}/${domain}.ext`, from: /{{DOMAIN}}/g, to: `${domain}` };
							replaced = replace.sync( options );

							execSync( `openssl genrsa -out "${getCertsPath}/${domain}/${domain}.key" 4096`, { stdio: 'ignore' } );
							execSync( `openssl req -new -key "${getCertsPath}/${domain}/${domain}.key" -out "${getCertsPath}/${domain}/${domain}.csr" -subj "/CN=*.${domain}.test"`, { stdio: 'ignore' } );
							execSync( `openssl x509 -req -in "${getCertsPath}/${domain}/${domain}.csr" -CA "${getCertsPath}/ca/ca.crt" -CAkey "${getCertsPath}/ca/ca.key" -CAcreateserial -out "${getCertsPath}/${domain}/${domain}.crt" -days 365 -sha256 -extfile "${getCertsPath}/${domain}/${domain}.ext"`, { stdio: 'ignore' } );
						}
					} );
				}
			} );
		}
    }
}
