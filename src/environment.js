const commands = require( "./commands" );
const { execSync } = require( 'child_process' );
const path = require( "./configure" );
const getRootPath = path.setRootPath();
const getGlobalPath = path.setGlobalPath();
const getConfigPath = path.setConfigPath();
const dockerFile = `${getGlobalPath}/docker-compose.yml`

const help = function() {
    const command = commands.command();

    const help = `
Usage:  wsldocker ${command} {container}
`;
    console.log( help );
    process.exit();
};

const up = async function() {
    execSync( `docker-compose -f ${dockerFile} up -d` );
};

const start = async function( args ) {
    if ( args == "wordpress" ) {
        execSync( `docker-compose -f ${dockerFile} start ${args}` );
    } else if ( args == "mysql" ) {
        execSync( `docker-compose -f ${dockerFile} start ${args}` );
    } else if ( args == "mailhog" ) {
        execSync( `docker-compose -f ${dockerFile} start ${args}` );
    } else {
        execSync( `docker-compose -f ${dockerFile} start` );
    }
}

const stop = async function( args ) {
    if ( args == "wordpress" ) {
        execSync( `docker-compose -f ${dockerFile} stop ${args}` );
    } else if ( args == "mysql" ) {
        execSync( `docker-compose -f ${dockerFile} stop ${args}` );
    } else if ( args == "mailhog" ) {
        execSync( `docker-compose -f ${dockerFile} stop ${args}` );
    } else {
        execSync( `docker-compose -f ${dockerFile} stop` );
    }
};

const restart = async function( args ) {
    if ( args == "wordpress" ) {
        execSync( `docker-compose -f ${dockerFile} restart ${args}` );
    } else if ( args == "mysql" ) {
        execSync( `docker-compose -f ${dockerFile} restart ${args}` );;
    } else if ( args == "mailhog" ) {
        execSync( `docker-compose -f ${dockerFile} restart ${args}` );;
    } else {
        execSync( `docker-compose -f ${dockerFile} restart` );
    }
};

const down = async function() {
    execSync( `docker-compose -f ${dockerFile} down` );
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
