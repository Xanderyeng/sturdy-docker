#!/usr/bin/env node

const path = require( "path" );
const rootPath = path.dirname( require.main.filename );
const srcPath = path.join( `${rootPath}/src` );
const configPath = path.join( `${rootPath}/config` );
const sitesPath = path.join( `${rootPath}/sites` );
