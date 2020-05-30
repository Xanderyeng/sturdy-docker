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

// Here, we will be using the require the js-yaml and fs file and read the .global/docker-custom.yml
const fs = require( "fs-extra" );
const yaml = require( "js-yaml" );
const replace = require( "replace-in-file" );
const shell = require( "shelljs" );
const { execSync } = require( 'child_process' );
const configuredHosts = require( "./hosts" );


// Here, we are going to copy the docker-custom to the global directory.
shell.exec( `bash ${getRootPath}/scripts/setup.sh` );

const config = yaml.safeLoad( fs.readFileSync( '.global/docker-custom.yml', 'utf8' ) );

// Here, we will setup the dashboard 
const setDashboard = config.default.domain;
const setDashboardRepo = config.default.repo;

for ( const dashboard of setDashboard ) {
    if ( ! fs.existsSync( `${getSitesPath}/${dashboard}/public_html` ) ) {
        fs.mkdir( `${getSitesPath}/${dashboard}/public_html`, { recursive: true }, error => {
            if ( error ) {
                console.log( `Failed to create directory for ${setSitesPath}/${dashboard}/public_html` );
            }
        } );
    }

    if ( ! fs.existsSync( `${getConfigPath}/nginx/${dashboard}.conf` ) ) {
        fs.copy( `${getConfigPath}/templates/nginx.conf`, `${getConfigPath}/nginx/${dashboard}.conf`, error => {
            if ( error ) {
                console.log( `failed to copy nginx.conf to ${dashboard}.conf` );
            } else {
                const options = {
                    files: `${getConfigPath}/nginx/${dashboard}.conf`,
                    from: /{{DOMAIN}}/g,
                    to: `${dashboard}`,
                };
                replaced = replace.sync( options );

                configuredHosts.set('127.0.0.1', `${dashboard}.test`, function (err) {
                    if (err) {
                      console.error(err)
                    } else {
                      console.log('set /etc/hosts successfully!')
                    }
                });

                // Here, we are going to run a bash script to grab information from GitHub.
                execSync( `bash ${getRootPath}/scripts/${dashboard}.sh` );
            }
        } );
    }
}

// Here we are going to setup the actual sites 
const domains = config.sites.domain;
const provision = config.sites.provision;
const setDomainRepo = config.sites.repo 

if ( provision == true ) {
    for ( const domain of domains ) {
        if ( ! fs.existsSync( `${getSitesPath}/${domain}/public_html` ) ) {
            fs.mkdir( `${getSitesPath}/${domain}/public_html`, { recursive: true }, error => {
                if ( error ) {
                    console.log( `failed to create directory for ${domain}` );
                }
            } );
        }

        if ( ! fs.existsSync( `${getConfigPath}/nginx/${domain}.conf` ) ) {
            fs.copy( `${getConfigPath}/templates/nginx.conf`, `${getConfigPath}/nginx/${domain}.conf`, error => {
                if ( error ) {
                    console.log( `failed to copy file` );
                } else {
                    const options = {
                        files: `${getConfigPath}/nginx/${domain}.conf`,
                        from: /{{DOMAIN}}/g,
                        to: `${domain}`,
                    };
                    replaced = replace.sync( options );
    
                    configuredHosts.set('127.0.0.1', `${domain}.test`, function (err) {
                        if (err) {
                          console.error(err)
                        } else {
                          console.log('set /etc/hosts successfully!')
                        }
                    });

                    shell.exec( `bash ${getRootPath}/scripts/sites.sh` );
                    shell.exec( `bash ${getRootPath}/scripts/wordpress.sh` );
                }
            } );
        }
    }
}

// here we here to generate the phpmyadmin and tls-ca
shell.exec( `bash ${getRootPath}/scripts/resources.sh` );