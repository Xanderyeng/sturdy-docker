#!/usr/bin/env node
const commands = require( './src/commands' );

const help = function() {
    let help = `
Usage: d4w [command]
Commands:
  provision Provision custom.yml file
  up        Create and Start Container
  down      Stop and Remove Container
  start     Start Services
  restart   Restart Services
  stop      Stop Services

Run 'd4w [command] help' for more information on a command.
`;
    console.log( help );
};

const version = function() {
    var pjson = require('./package.json');
    console.log( 'Docker for WordPress' );
    console.log( `Version: ${pjson.version}` );
};

const init = async function() {
    let command = commands.command();

    switch ( command ) {
        case 'provision':
            await require( "./src/provision" );
            break;
        case 'up':
        case 'start':
        case 'restart':
        case 'stop':
        case 'down':
        case 'pull':
            await require( "./src/environment" ).command();
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
