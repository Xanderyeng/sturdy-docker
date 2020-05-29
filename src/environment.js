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

const setCertsPath = function() {
    return certsPath;
}

const setConfigPath = function() {
    return configPath;
}

const setDatabasesPath = function() {
    return databasePath;
}

const setLogsPath = function() {
    return logsPath;
}

const setSrcPath = function() {
    return srcPath;
}

const setSitesPath = function() {
    return sitesPath;
}

module.exports = { setRootPath, setCertsPath, setConfigPath, setDatabasesPath, setLogsPath, setSrcPath, setSitesPath };