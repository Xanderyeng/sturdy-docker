#!/usr/bin/env node

const command = function() {
    const command = process.argv[2];
    if ( typeof command === 'undefined' ) {
        return;
    }
    return process.argv[2].toLowerCase();
};

const subcommand = function() {
    const subcommand = process.argv[3];

    if ( typeof subcommand !== 'undefined' ) {
        return process.argv[3].toLowerCase();
    }
    return;
};
module.exports = { command, subcommand };