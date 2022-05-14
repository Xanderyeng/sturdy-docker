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
const default_dashboard = Object.entries( config.default );
const sites_defaults = Object.entries( config.sites );

const wsl_host = function() {
    if ( isWSL ) {
		for ( const [ name, value ] of default_dashboard ) {
			const host = value.host;

			execSync( `sturdydocker-hosts add ${host}` );
		}

		for ( const [ name, value ] of sites_defaults ) {
			const host = value.host;

			execSync( `sturdydocker-hosts add ${host}` );
		}
    } else {
		for ( const [ name, value ] of default_dashboard ) {
			const host = value.host;

			execSync( `sudo sturdydocker-hosts add ${host}` );
		}

		for ( const [ name, value ] of sites_defaults ) {
			const host = value.host;

			execSync( `sudo sturdydocker-hosts add ${host}` );
		}
    }
};

module.exports = { wsl_host };
