#!/usr/bin/env node

// Here, we have the basic paths to different directory without the need to 
// reconfigured, just extended if necessary. Some of these may not needed will
// be taken out later once this project is complete.
const path = require( "./environment" );
const getRootPath = path.setRootPath();
const getCertsPath = path.setCertsPath();
const getDatabasesPath = path.setDatabasesPath();
const getLogsPath = path.setLogsPath();
const getSitesPath = path.setSitesPath();
const getSrcPath = path.setSrcPath();