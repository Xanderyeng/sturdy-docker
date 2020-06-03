const path = require( './configure' );
const commands = require( './commands' );
const { execSync} = require( 'child_process' );
const getComposeFile = path.setComposeFile();

const images = {
    'benlumia007/nginx:php7.2-fpm' : `benlumia007/nginx:php7.2-fpm`,
    'benlumia007/mysql:latest'     : 'benlumia007/mysql:latest',
    'benlumia007/mailhog:latest'   : 'benlumia007/mailhog'
};

const help = function() {
     const help = `
Usage:  wsldocker image {container}
`;
    console.log( help );
    process.exit();
};
const pull = function() {
	execSync( `docker-compose -f ${getComposeFile} pull`, { stdio: 'inherit' } );
}

const command = async function() {
	switch ( commands.subcommand() ) {
		case 'pull':
			pull();
			break;
		default:
			help();
			break;
	}
};

module.exports = { command, pull };
