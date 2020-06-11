#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( './configure' );
const { execSync, exec } = require( 'child_process' );
const getComposeFile = path.setComposeFile();

execSync( `docker-compose -f ${getComposeFile} exec nginx make`, { stdio: 'inherit' } );
