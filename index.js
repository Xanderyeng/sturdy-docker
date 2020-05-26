#!/usr/bin/env node
const commandUtils = require( './src/command-utils' );

const help = function() {
    let help = `
Usage: d4w COMMAND
Commands:
  up        Create and Start Container
  down      Stop and Remove Container
  start     Start Services
  restart   Restart Services
  stop      Stop Services

Run 'd4w COMMAND help' for more information on a command.
`;
    console.log( help );
};

const version = function() {
    var pjson = require('./package.json');
    console.log( 'WP Local Docker' );
    console.log( `Version ${pjson.version}` );
};

const init = async function() {
    let command = commandUtils.command();

    switch ( command ) {
        case 'start':
        case 'stop':
        case 'restart':
        case 'destroy':
        case 'up':
            await require('./src/environment').command();
            break;
        case '--version':
        case '-v':
            version();
            break;
        default:
            help();
            break;
    }
};
init();