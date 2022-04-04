#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( "../src/configure" );
const getConfigPath = path.setConfigPath();
const getGlobalPath = path.setGlobalPath();
const getComposeFile = path.setComposeFile();
const getCustomFile = path.setCustomFile();

// Here, we will be using the require the js-yaml and fs file and read the .global/docker-custom.yml
const fs = require( "fs-extra" );
const yaml = require( "js-yaml" );
const { execSync } = require( 'child_process' );

// Here, we are going to load the custom.yml file so that we can begin automation.
const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );

// Let's create some main variables for each components from the custom.yml.
const dashboard_defaults = Object.entries( config.default );
const options_defaults = Object.entries( config.options );
const sites_defaults = Object.entries( config.sites );
const resources_defaults = Object.entries( config.resources );

// Here, we are going to setup dashboard.
for ( const [ name, value ] of dashboard_defaults ) {
    const provision = value.provision;
    const repo = value.repo;
    const php = config.php;
    const dir = `/srv/www/${name}`

    execSync( `docker-compose -f ${getComposeFile} exec server bash /app/dashboard.sh ` + name + ' ' + provision + ' ' + repo + ' ' + php + ' ' + dir, { stdio: 'inherit' } );
}

// Here, we are going to setup options such s db_backups and db_restores.
for ( const [ name, value ] of options_defaults ) {
    if ( name == 'db_restores' ) {
        execSync( `docker-compose -f ${getComposeFile} exec server bash /app/databases.sh ` + name + ' ' + value, { stdio: 'inherit' } );
    }
}

// Here, we are going to automate sites.
for ( const [ name, value ] of sites_defaults ) {
    const provision = value.provision;
    const repo = value.repo;
    const dir = `/srv/www/${name}`;
    const custom = `/srv/.global/custom.yml`;

    execSync( `docker-compose -f ${getComposeFile} exec server bash /app/sites.sh ` + name + ' ' + provision + ' ' + repo + ' ' + dir + ' ' + custom, { stdio: 'inherit' } );
}

// Here, we are going to setup resources.
for ( const [ name, value ] of resources_defaults ) {
    const utilities = Object.entries( value.utilities );
    const repo = value.repo;

    for ( const [ utility, key ] of utilities ) {
        execSync( `docker-compose -f ${getComposeFile} exec server bash /app/resources.sh ` + key + ' ' + repo + ' ' + name + ' ' + utility, { stdio: 'inherit' } );
    }
}

// Here, we are going to restart nginx so that all generated sites are loaded properly.
execSync( `docker-compose -f ${getComposeFile} exec server bash /app/services.sh`, { stdio: 'inherit' } );

// Here, we are going to make sure that the hosts file are setup properly.
const getWSL = require( '../src/wsl' );
getWSL.wsl_host();