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

execSync( `docker-compose -f ${getComposeFile} exec apache make docker-setup`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec mysql make docker-restore`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache make docker-dashboard`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache make docker-sites`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache make docker-resources`, { stdio: 'inherit' } );

const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );
const sites = config.sites;

if ( isWSL ) {
    
    execSync( `wp4docker-hosts add dashboard.test` );

    for ( const domain of Object.keys( sites ) ) {
        execSync( `wp4docker-hosts add ${domain}.test` );
    }
} else {
    execSync( `sudo wp4docker-hosts add dashboard.test` );

    for ( const domain of Object.keys( sites ) ) {
        execSync( `sudo wp4docker-hosts add ${domain}.test` );
    }
}