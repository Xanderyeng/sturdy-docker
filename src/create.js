const commands = require( './commands' );
const path = require( './configure' );
const getRootPath = path.setRootPath();

const help = function() {
	let help = `


`;
console.log( help);
process.exit();
};

const createEnv = function() {
	let domain = commands.subcommand();

	console.log( domain );
};

const command = async function() {
	switch ( commands.command() ) {
		case 'pull':
			pull();
			break;
		default:
			createEnv();
			break;
	}
};

module.exports = { command, createEnv, help };
