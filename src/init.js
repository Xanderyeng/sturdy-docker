#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( "./configure" );
const getConfigPath = path.setConfigPath();
const getGlobalPath = path.setGlobalPath();
const getComposeFile = path.setComposeFile();
const getCustomFile = path.setCustomFile();

// Here, we will be using the require the js-yaml and fs file and read the .global/docker-custom.yml
const fs      = require( 'fs-extra' );
const yaml    = require( 'js-yaml' );
const replace = require( 'replace-in-file' );
const { exec, spawn } = require( 'child_process' );

// If custom.yml doesn't exist in the .global folder, then copy from default.yml to custom.yml.
if ( ! fs.existsSync( `${getCustomFile}` ) ) {
    fs.copyFileSync( `${getConfigPath}/default.yml`, `${getGlobalPath}/custom.yml` );
    fs.copyFileSync( `${getConfigPath}/compose.yml`, `${getGlobalPath}/docker-compose.yml` );
};

// Here, we are going to load the custom.yml file so that we can begin automation.
const config = yaml.safeLoad( fs.readFileSync( `${getCustomFile}`, 'utf8' ) );

// Let's create some main variables for each components from the custom.yml.
const server = config.server;
const php = config.php;

if ( server == 'nginx' ) {
    if ( php == '7.4' ) {
        if ( exec( `grep -q sturdy-docker:lemp8.0-fpm ${getComposeFile}` ) ) {
            const options = {
                files: `${getComposeFile}`,
                from: /sturdy-docker:lemp8.0-fpm/g,
                to: 'sturdy-docker:lemp7.4-fpm'
            };
        
            try {
                const results = replace.sync( options );
              }
            catch {}
        }
        
        if ( exec( `grep -q sturdy-docker:lemp8.1-fpm ${getComposeFile}` ) ) {
            const options = {
                files: `${getComposeFile}`,
                from: /sturdy-docker:lemp8.1-fpm/g,
                to: 'sturdy-docker:lemp7.4-fpm'
            };
        
            try {
                const results = replace.sync( options );
              }
            catch {}
        }
    }

    if ( php == '8.0' ) {
        if ( exec( `grep -q sturdy-docker:lemp7.4-fpm ${getComposeFile}` ) ) {
            const options = {
                files: `${getComposeFile}`,
                from: /sturdy-docker:lemp7.4-fpm/g,
                to: 'sturdy-docker:lemp8.0-fpm'
            };
        
            try {
                const results = replace.sync( options );
              }
            catch {}
        }

        if ( exec( `grep -q sturdy-docker:lemp8.1-fpm ${getComposeFile}` ) ) {
            const options = {
                files: `${getComposeFile}`,
                from: /sturdy-docker:lemp8.1-fpm/g,
                to: 'sturdy-docker:lemp8.0-fpm'
            };
        
            try {
                const results = replace.sync( options );
              }
            catch {}
        }
    }

    if ( php == '8.1' ) {
        if ( exec( `grep -q sturdy-docker:lemp7.4-fpm ${getComposeFile}` ) ) {
            const options = {
                files: `${getComposeFile}`,
                from: /sturdy-docker:lemp7.4-fpm/g,
                to: 'sturdy-docker:lemp8.1-fpm'
            };
        
            try {
                const results = replace.sync( options );
              }
            catch {}
        }

        if ( exec( `grep -q sturdy-docker:lemp8.0-fpm ${getComposeFile}` ) ) {
            const options = {
                files: `${getComposeFile}`,
                from: /sturdy-docker:lemp8.0-fpm/g,
                to: 'sturdy-docker:lemp8.1-fpm'
            };
        
            try {
                const results = replace.sync( options );
              }
            catch {}
        }
    }
}