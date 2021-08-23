#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( './configure' );
const { execSync } = require( 'child_process' );
const getComposeFile = path.setComposeFile();

execSync( `docker-compose -f ${getComposeFile} exec apache2 make docker-setup`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec mysql make docker-restore`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache2 make docker-dashboard`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache2 make docker-sites`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache2 make docker-resources`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec apache2 make docker-services`, { stdio: 'inherit' } );

const getWSL = require( './wsl' );
getWSL.wsl_host();