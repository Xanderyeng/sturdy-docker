#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( "../src/configure" );
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
const { execSync } = require( 'child_process' );
const getComposeFile = path.setComposeFile();
const getCustomFile = path.setCustomFile();
const getWSL = require( '../src/wsl' );


const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );

const dashboard_defaults = Object.entries( config.default );
const options_defaults = Object.entries( config.options );
const sites_defaults = Object.entries( config.sites );
const resources_defaults = Object.entries( config.resources );

for ( const [ name, value ] of dashboard_defaults ) {
    const provision = value.provision;
    const repo = value.repo;

    execSync( `docker-compose -f ${getComposeFile} exec server bash dashboard.sh ` + name + ' ' + provision + ' ' + repo, { stdio: 'inherit' } );
}

for ( const [ name, value ] of options_defaults ) {
    
    if ( name == 'db_restores' ) {
        execSync( `docker-compose -f ${getComposeFile} exec server bash databases.sh ` + name + ' ' + value, { stdio: 'inherit' } );
    }
}

for ( const [ name, value ] of sites_defaults ) {
    const provision = value.provision;
    const repo = value.repo;

    execSync( `docker-compose -f ${getComposeFile} exec server bash sites.sh ` + name + ' ' + provision + ' ' + repo, { stdio: 'inherit' } );
}

for ( const [ name, value ] of resources_defaults ) {
    const repo = "https://github.com/benlumia007/sturdy-docker-resources.git"
    execSync( `docker-compose -f ${getComposeFile} exec server bash resources.sh ` + value + ' ' + repo, { stdio: 'inherit' } );
}

execSync( `docker-compose -f ${getComposeFile} exec server sudo service apache2 restart > /dev/null 2>&1`, { stdio: 'inherit' } );

getWSL.wsl_host();