const path = require( './configure' );
const { execSync } = require( 'child_process' );
const getComposeFile = path.setComposeFile();

let started = false;

const waitForDatabase = function() {
	const waitTime = 10000;
	const waitInterval = 500;
	let currentTime = 0;

	const incTime = () => {
		currentTime += waitInterval;
		const p = Math.floor( ( currentTime / waitTime) * 100 )
		process.stdout.clearLine();
		process.stdout.cursorTo(0);
		process.stdout.write( `waiting for database ... ${p}%`);
	};

	const timerFinished = () => {
		clearInterval(interval);
		process.stdout.clearLine();
		process.stdout.cursorTo(0);
	};

	const interval = setInterval( incTime, waitInterval );
	setTimeout( timerFinished, waitTime );
}

const startGateway = function() {
    try {
        const output = execSync( `docker-compose -f ${getComposeFile} ps` ).toString();

        if ( ! output ) {
            execSync( `docker-compose -f ${getComposeFile} up -d` );
        } else {
			execSync( `docker-compose -f ${getComposeFile} start` );
		}
    } catch (ex) {}


	waitForDatabase();
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
