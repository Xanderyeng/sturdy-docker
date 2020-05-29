#!/usr/bin/env node

const path = require( "path" );
const rootPath = path.dirname( require.main.filename );
const certsPath = path.join( `${rootPath}/certificates` );
const configPath = path.join( `${rootPath}/config` );
const databasePath = path.join( `${rootPath}/databases` );
const logsPath = path.join( `${rootPath}/logs` );
const srcPath = path.join( `${rootPath}/src` );
const sitesPath = path.join( `${rootPath}/sites` );

const setRootPath = function() {
    return rootPath;
}

module.exports = { setRootPath };