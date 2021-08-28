#!/usr/bin/env node
const commands = require( './src/commands' );

const help = function() {
    let help = `
Usage: sturdydocker [command]

Commands:

provision   Creae new WordPress site or sites
restart     Restarts one or more container
shell       Opens a shell for a specific container
start       Starts one or more container
stop        Stops one or more container
up          Starts one or more container
down        Destroys one or more container
pull        Pull image or images
logs        Fetch the logs of a container

Run 'sturdydocker [command] help' for more information on a command.
`;
    console.log( help );
};

const version = function() {
    var pjson = require('./package.json');
    console.log( 'Sturdy Docker' );
    console.log( `Version: ${pjson.version}` );
};

const init = async function() {
    let command = commands.command();

    switch ( command ) {
        case 'provision':
            require( "./src/provision" );
            break;
        case 'down':
        case 'restart':
        case 'start':
        case 'logs':
        case 'ps':
        case 'stop':
        case 'shell':
        case 'up':
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
