const commands = require( "./commands" );
const { execSync } = require( 'child_process' );
const path = require( "./configure" );
const getComposeFile = path.setComposeFile();

const help = function() {
    const command = commands.command();

    const help = `
Usage:  sturdydocker ${command}
`;
    console.log( help );
    process.exit();
};

const up = async function() {
    execSync( `docker-compose -f ${getComposeFile} up -d` );
};

const start = async function() {
    execSync( `docker-compose -f ${getComposeFile} start`, { stdio: 'inherit' } );
}

const stop = async function() {
    execSync( `docker-compose -f ${getComposeFile} exec server make docker-backup`, { stdio: 'inherit' } );
    execSync( `docker-compose -f ${getComposeFile} stop`, { stdio: 'inherit' } );
};

const restart = async function() {
    execSync( `docker-compose -f ${getComposeFile} restart`, { stdio: 'inherit' } );
};

const down = async function() {
    execSync( `docker-compose -f ${getComposeFile} exec server make docker-backup`, { stdio: 'inherit' } );
    execSync( `docker-compose -f ${getComposeFile} down` );
};

const pull = async function() {
    execSync( `docker-compose -f ${getComposeFile} pull`, { stdio: 'inherit' } );
}

const logs = async function() {
    execSync( `docker logs server`, { stdio: 'inherit' } );
}

const ps = async function() {
    try {
        execSync( `docker ps`, { stdio: 'inherit' } );
    } catch ( ex ) {}
}

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
            case 'stop':
                stop();
                break;
            case 'down':
                down();
                break;
            case 'pull':
                pull();
                break;
            case 'logs':
                logs();
                break;
            case 'ps':
                ps();
                break;
            default:
                help();
                break;
        }
    }
};

module.exports = { command, start, stop, restart, down, up, pull, logs, ps, help };
