#!/usr/bin/env node
const commands = require( './src/commands' );

const help = function() {
    let help = `
Usage: wsldocker [command]

Commands:

  create	Create a new WordPress site
  delete	Delete a WordPress site
  image		Manage docker images
  restart	Restarts one or more containers
  shell		Opens a shell for a specific container ( default: nginx )
  start		Starts one or more containers
  stop		Stops one or more containers

Run 'wsldocker [command] help' for more information on a command.
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
            require( "./src/provision" );
			break;
		case 'create':
			await require( './src/create' ).command();
			break;
		case 'delete':
			await require( './src/delete' );
        case 'start':
        case 'restart':
        case 'stop':
            await require( "./src/environment" ).command();
			break;
		case  'image':
			await require( './src/image' ).command();
			break;
		case 'shell':
			await require( './src/shell' ).command();
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
