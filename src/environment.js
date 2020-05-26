#!/usr/bin/env node

const commandUtils = require( './command-utils' );
const { execSync } = require( 'child_process' )
const path = require( "path" );
const rootPath = path.dirname( require.main.filename );
const globalPath = path.join( rootPath, ".global" );
const DockerFile = path.join( globalPath, 'docker-compose.yml');
const bin = path.join( rootPath, "config", "bin" );

const help = function() {
    const command = commandUtils.command();

    const help = `
Usage:  sandbox ${command}
`;
    console.log( help );
    process.exit();
};

const start = async function() {
    execSync( `docker-compose -f ${DockerFile} start` );
};

const stop = async function() {
    execSync( `bash ${bin}/docker-backup` );
    execSync( `docker-compose -f ${DockerFile} stop` );
};

const restart = async function() {
    execSync( `docker-compose -f ${DockerFile} restart` );;
};

const destroy = async function() {
    execSync( `docker-compose -f ${DockerFile} down` );
};

const up = async function() {
    execSync( `docker-compose -f ${DockerFile} up -d` );
};

const pull = async function() {
    execSync( `docker-compose -f ${DockerFile} pull` );
};

const provision = async function() {
    execSync( "make" );
};

const command = async function() {
    if ( commandUtils.subcommand() === 'help' || commandUtils.subcommand() === false ) {
        help();
    } else {
        switch ( commandUtils.command() ) {
            case 'start':
                start();
                break;
            case 'stop':
                stop();
                break;
            case 'restart':
                restart();
                break;
            case 'destroy':
                destroy();
                break;
            case 'up':
                up();
                break;
            case 'pull':
                pull();
                break;
            case 'provision':
                provision();
                break;
            default:
                help();
                break;
        }
    }
};

module.exports = { command, start, stop, restart, destroy, up, pull, provision, help };