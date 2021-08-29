#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( './configure' );
const { execSync } = require( 'child_process' );
const fs = require( 'fs-extra' );
const yaml = require( 'js-yaml' );
const getCustomFile = path.setCustomFile();
const isWSL = require( 'is-wsl' );

const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );
const sites = config.sites;

const wsl_host = function() {
    if ( isWSL ) {
    
        execSync( `sturdydocker-hosts add dashboard.test` );
    
        for ( const domain of Object.keys( sites ) ) {
            execSync( `sturdydocker-hosts add ${domain}.test` );
        }
    } else {
        execSync( `sudo sturdydocker-hosts add dashboard.test` );
    
        for ( const domain of Object.keys( sites ) ) {
            execSync( `sudo sturdydocker-hosts add ${domain}.test` );
        }
    }
};

module.exports = { wsl_host };