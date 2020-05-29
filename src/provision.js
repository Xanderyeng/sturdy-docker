#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to 
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( "./environment" );
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
const config = yaml.safeLoad( fs.readFileSync( '.global/docker-custom.yml', 'utf8' ) );

// Here, we will be using replace-in-file to replace certain words into .conf file.
const replace = require( "replace-in-file" );

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
                replaced = replace.sync( options )
            }
        } );
    }
}