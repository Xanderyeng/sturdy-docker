const commands = require( "./commands" );
const { execSync } = require( 'child_process' );
const path = require( "./configure" );
const getRootPath = path.setRootPath();
const getGlobalPath = path.setGlobalPath();
const getConfigPath = path.setConfigPath();
const getComposeFile = path.setComposeFile();

const help = function() {
    const command = commands.command();

    const help = `
Usage:  wsldocker ${command} {container}
`;
    console.log( help );
    process.exit();
};

const up = async function() {
    execSync( `docker-compose -f ${getComposeFile} up -d` );
};

const start = async function( args ) {
    if ( args == "server" ) {
        execSync( `docker-compose -f ${getComposeFile} start ${args}` );
    } else if ( args == "mysql" ) {
        execSync( `docker-compose -f ${getComposeFile} start ${args}` );
    } else if ( args == "mailhog" ) {
        execSync( `docker-compose -f ${getComposeFile} start ${args}` );
    } else {
        execSync( `docker-compose -f ${getComposeFile} start` );
    }
}

const stop = async function( args ) {
    execSync( `docker-compose -f ${getComposeFile} exec mysql make docker-backup`, { stdio: 'inherit' } );
    if ( args == "server" ) {
        execSync( `docker-compose -f ${getComposeFile} stop ${args}` );
    } else if ( args == "mysql" ) {
        execSync( `docker-compose -f ${getComposeFile} stop ${args}` );
    } else if ( args == "mailhog" ) {
        execSync( `docker-compose -f ${getComposeFile} stop ${args}` );
    } else {
        execSync( `docker-compose -f ${getComposeFile} stop` );
    }
};

const restart = async function( args ) {
    if ( args == "server" ) {
        execSync( `docker-compose -f ${getComposeFile} restart ${args}` );
    } else if ( args == "mysql" ) {
        execSync( `docker-compose -f ${getComposeFile} restart ${args}` );;
    } else if ( args == "mailhog" ) {
        execSync( `docker-compose -f ${getComposeFile} restart ${args}` );;
    } else {
        execSync( `docker-compose -f ${getComposeFile} restart` );
    }
};

const down = async function() {
    execSync( `docker-compose -f ${getComposeFile} exec mysql make docker-backup`, { stdio: 'inherit' } );
    execSync( `docker-compose -f ${getComposeFile} down` );
};

const command = async function() {
    if ( commands.subcommand() === 'help' || commands.subcommand() === false ) {
        help();
    } else {
        switch ( commands.command() ) {
            case 'up':
                up();
                break;
            case 'start':
                start( commands.subcommand() );
                break;
            case 'restart':
                restart( commands.subcommand() );
                break;
            case 'stop':
                stop( commands.subcommand() );
                break;
            case 'down':
                down();
                break;
            default:
                help();
                break;
        }
    }
};

module.exports = { command, start, stop, restart, down, up, help };
