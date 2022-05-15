#!/usr/bin/env node
const commands = require( '../src/commands' );

const help = function() {
    let help = `
Usage: sturdydocker [command]

Commands:

init        Create intial custom file
provision   Creae new site or sites
restart     Restart server container
shell       Bash shell for server container
start       Start server container
stop        Stop server container
up          Start server container
down        Destroy server container
pull        Pull image for server container
logs        Fetch log for server container

Run 'sturdydocker [command] help' for more information on a command.
`;
    console.log( help );
};

const version = function() {
    var pjson = require( '../package.json' );
    console.log( 'Sturdy Docker' );
    console.log( `Version: ${pjson.version}` );
};

const init = async function() {
    let command = commands.command();

    switch ( command ) {
        case 'init':
            require( '../src/init' );
            break;
        case 'provision':
            require( "../src/provision" );
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
            await require( "../src/environment" ).command();
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
