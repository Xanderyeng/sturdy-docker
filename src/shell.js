
const commands = require( './commands' );
const path = require( './configure' );
const { execSync } = require( 'child_process' );
const getComposeFile = path.setComposeFile();

const command = async function() {
    const container = commands.subcommand() || 'server';

    try {
        if ( container === 'mailhog' ) {
			console.log( "does not have a bash" );
		} else {
			execSync( `docker-compose -f ${getComposeFile} exec ${container} bash`, { stdio: 'inherit' } );
		}
    } catch ( ex ) {}

    process.exit();
};

module.exports = { command };
