#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( './configure' );
const { execSync } = require( 'child_process' );
const fs = require( 'fs-extra' );
const yaml = require( 'js-yaml' );
const getComposeFile = path.setComposeFile();
const getCustomFile = path.setCustomFile();
const isWSL = require( 'is-wsl' );

execSync( `docker-compose -f ${getComposeFile} exec nginx make docker-setup`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec mysql make docker-restore`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec nginx make docker-dashboard`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec nginx make docker-sites`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec nginx make docker-resources`, { stdio: 'inherit' } );

const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );
const sites = config.sites;

if ( isWSL ) {
    
    execSync( `wp4docker-hosts set 127.0.0.1 dashboard.test` );

    for ( const domain of Object.keys( sites ) ) {
        execSync( `wp4docker-hosts set 127.0.0.1 ${domain}.test` );
    }
} else {
    execSync( `sudo wp4docker-hosts set 127.0.0.1 dashboard.test` );

    for ( const domain of Object.keys( sites ) ) {
        execSync( `sudo wp4docker-hosts set 127.0.0.1 ${domain}.test` );
    }
}