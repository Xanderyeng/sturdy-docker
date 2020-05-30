const commands = require( "./commands" );
const { execSync } = require( 'child_process' );
const path = require( "./configure" );
const getGlobalPath = path.setGlobalPath();
const dockerFile = `${getGlobalPath}/docker-compose.yml`

const help = function() {
    const command = commands.command();

    const help = `
Usage:  sandbox ${command}
`;
    console.log( help );
    process.exit();
};

const start = async function() {
    execSync( `docker-compose -f ${dockerFile} start` );
};

const stop = async function() {
    execSync( `docker-compose -f ${dockerFile} stop` );
};

const restart = async function() {
    execSync( `docker-compose -f ${dockerFile} restart` );;
};

const destroy = async function() {
    execSync( `docker-compose -f ${dockerFile} down` );
};

const up = async function() {
    execSync( `docker-compose -f ${dockerFile} up -d` );
};

const pull = async function() {
    execSync( `docker-compose -f ${dockerFile} pull` );
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
                start();
                break;
            case 'restart':
                restart();
                break;
            case 'destroy':
                destroy();
                break;
            case 'pull':
                pull();
                break;
            default:
                help();
                break;
        }
    }
};

module.exports = { command, start, stop, restart, destroy, up, pull, help };