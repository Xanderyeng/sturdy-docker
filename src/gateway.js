const path = require( './configure' );
const { execSync } = require( 'child_process' );
const getComposeFile = path.setComposeFile();

let started = false;

const startGateway = function() {
    try {
        const output = execSync( `docker-compose -f ${getComposeFile} ps` ).toString();

        if ( ! output ) {
            execSync( `docker-compose -f ${getComposeFile} up -d`, {stdio: 'inherit' } );
        } else {
			execSync( `docker-compose -f ${getComposeFile} start`, { stdio: 'inherit' } );
		}
    } catch (ex) {}
}

const stopGateway = function() {
	execSync( `docker-compose -f ${getComposeFile} stop`);
}

const restartGateway = function() {
	execSync( `docker-compose -f ${getComposeFile} restart`);
}

const startGlobal = async function() {
	if ( started === true ) {
		return;
	}

	startGateway();

	started = true;
}

const stopGlobal = function() {
	stopGateway();

	started = false;
}

const restartGlobal = function() {
	restartGateway();
	started = true;
}



module.exports = { startGlobal, stopGlobal, restartGlobal }
