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

const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );

// Here we are going to setup the actual sites
const domains = config.sites.domain;
const provision = config.sites.provision;
const setDomainPHP = config.preprocessor;

if ( provision == true ) {
    for ( const domain of domains ) {
        if ( ! fs.existsSync( `${getSitesPath}/${domain}/public_html` ) ) {
			shell.mkdir( `-p`, `${getSitesPath}/${domain}/public_html` );
        }

        if ( ! fs.existsSync( `${getConfigPath}/nginx/${domain}.conf` ) ) {
			shell.cp( `-r`, `${getConfigPath}/templates/nginx.conf`, `${getConfigPath}/nginx/${domain}.conf` );
			const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /{{DOMAIN}}/g, to: `${domain}` };
			replaced = replace.sync( options );


			if ( isWSL ) {
				configuredHosts.set('127.0.0.1', `${domain}.test`, function (err) {
					if (err) {
					  console.error(err)
					} else {
					  console.log('set /etc/hosts successfully!')
					}
				});
			} else {
				shell.exec( `sudo d4w-hosts set 127.0.0.1 ${domain}.test` );
			}
		}

		for ( const getDomainPHP of setDomainPHP ) {
			if ( getDomainPHP == "7.2" ) {
				if ( shell.grep( `-i`, `7.3`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /7.3/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}

				if ( shell.grep( `-i`, `7.4`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /7.4/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}

				if ( shell.grep( `-i`, `{{PHPVERSION}}`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /{{PHPVERSION}}/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}
			} else if ( getDomainPHP == "7.3" ) {
				if ( shell.grep( `-i`, `7.2`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /7.2/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}

				if ( shell.grep( `-i`, `7.4`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /7.4/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}

				if ( shell.grep( `-i`, `{{PHPVERSION}}`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /{{PHPVERSION}}/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}
			} else if ( getDomainPHP == "7.4" ) {
				if ( shell.grep( `-i`, `7.2`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /7.2/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}

				if ( shell.grep( `-i`, `7.3`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /7.3/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}

				if ( shell.grep( `-i`, `{{PHPVERSION}}`, `${getConfigPath}/nginx/${domain}.conf` ) ) {
					const options = { files: `${getConfigPath}/nginx/${domain}.conf`, from: /{{PHPVERSION}}/g, to: `${getDomainPHP}` };
					replaced = replace.sync( options );
				}
			}
		}

		if ( ! fs.existsSync( `${getSitesPath}/${domain}/public_html/wp-config.php` ) ) {
			const dir = `/srv/www/${domain}/public_html`;

			shell.exec( `docker-compose -f ${compose} exec -T mysql mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"` );
			shell.exec( `docker-compose -f ${compose} exec -T mysql mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"` );
			shell.exec( `docker-compose -f ${compose} exec -T mysql mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'wordpress'@'%' WITH GRANT OPTION;"` );

			shell.exec( `docker-compose -f ${compose} exec -T mysql mysql -u root -e "FLUSH PRIVILEGES;"` );

			shell.exec( `docker-compose -f ${compose} exec -T nginx wp core download --path="${dir}" --quiet --allow-root` );
			shell.exec( `docker-compose -f ${compose} exec -T nginx wp config create --dbhost=mysql --dbname=${domain} --dbuser=wordpress --dbpass=wordpress --path="${dir}" --quiet --allow-root` );
			shell.exec( `docker-compose -f ${compose} exec -T nginx wp core install  --url="https://${domain}.test" --title="${domain}.test" --admin_user=admin --admin_password=password --admin_email="admin@${domain}.test" --skip-email --quiet --path=${dir} --allow-root` );
			shell.exec( `docker-compose -f ${compose} exec -T nginx wp plugin delete akismet --path=${dir} --quiet --allow-root` );
			shell.exec( `docker-compose -f ${compose} exec -T nginx wp plugin delete hello --path=${dir} --quiet --allow-root` );
			shell.exec( `docker-compose -f ${compose} exec -T nginx wp config shuffle-salts --path=${dir} --quiet --allow-root` );

			shell.exec( `docker-compose -f ${compose} exec -T nginx chown -R 1000:1000 ${dir}` );
		}
    }
}
