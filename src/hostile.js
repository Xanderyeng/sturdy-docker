const fs = require('fs');
const once = require('once');
const split = require('split');
const through = require('through');
const net = require('net');
const isWSL = require( "is-wsl" );

const windows = isWSL;
const EOL = windows
  ? '\r\n'
  : '\n'

exports.HOSTS = windows
  ? '/mnt/c/Windows/System32/drivers/etc/hosts'
  : '/etc/hosts'

const getFile = function( filePath, preserveFormatting, cb ) {
  const lines = [];
  if ( typeof cb !== 'function' ) {
    
    fs.readFileSync( filePath, { encoding: 'utf8' }).split(/\r?\n/).forEach( online );
    
    return lines;
  }

  cb = once( cb );

  fs.createReadStream( filePath, { encoding: 'utf8' } )
    .pipe( split() )
    .pipe( through( online ) )
    .on( 'close', function() {
      cb( null, lines )
    } )
    .on( 'error', cb );

  function online( line ) {
    
    const lineSansComments = line.replace( /#.*/, '' );
    
    const matches = /^\s*?(.+?)\s+(.+?)\s*$/.exec( lineSansComments );

    if ( matches && matches.length === 3 ) {

      const ip = matches[1];
      const host = matches[2];
      lines.push([ ip, host ] );

    } else {
      if ( preserveFormatting ) {
        lines.push( line );
      }
    }
  }
};

const get = function( preserveFormatting, cb ) {
  return getFile( exports.HOSTS, preserveFormatting, cb );
};

const set = function( ip, host, cb ) {
  let update = false;

  if ( typeof cb !== 'function' ) {
    return _set( exports.get( true ) );
  }

  get( true, function( err, lines ) {
    if ( err ) {
      return cb( err );
    } 

    _set( lines );
  } );

  function _set( lines ) {

    lines = lines.map( mapFunc );

    if ( ! update ) {

      const lastLine = lines[ lines.length - 1 ];
      if ( typeof lastLine === 'string' && /\s*/.test( lastLine ) ) {
        lines.splice( lines.length - 1, 0, [ ip, host ] );
      } else {
        lines.push([ ip, host ] );
      }
    }

    writeFile( lines, cb );
  }

  function mapFunc( line ) {
    
    if ( Array.isArray( line ) && line[1] === host && net.isIP( line[0] ) === net.isIP( ip ) ) {
      line[0] = ip;
      update = true;
    }
    return line;
  }
}

const remove = function( ip, host, cb ) {
  if ( typeof cb !== 'function' ) {
    return _remove( exports.get( true ) );
  }

  get( true, function( err, lines ) {
    if ( err ) {
      return cb( err );
    } 

    _remove( lines )
  } );

  function _remove( lines ) {
    lines = lines.filter( filterFunc );
    return writeFile( lines, cb );
  }

  function filterFunc( line ) {
    return ! ( Array.isArray( line ) && line[0] === ip && line[1] === host );
  }
};

const writeFile = function( lines, cb ) {
  lines = lines.map( function( line, lineNum ) {
    if ( Array.isArray( line ) ) {
      line = line[0] + ' ' + line[1];
    }
    return line + ( lineNum === lines.length -1 ? '' : EOL )
  } );

  if ( typeof cb !== 'function' ) {
    const stat = fs.statSync( exports.HOSTS );

    fs.writeFileSync( exports.HOSTS, lines.join( '' ), { mode: stat.mode } );

    return true;
  }

  cb = once( cb );

  fs.stat( exports.HOSTS, function ( err, stat ) {
    if ( err ) {
      return cb( err );
    }

    const s = fs.createWriteStream( exports.HOSTS, { mode: stat.mode } );
    s.on( 'close', cb );
    s.on('error', cb);

    lines.forEach( function( data ) {
      s.write( data )
    } );

    s.end();
  })

};

module.exports = { get, remove, set, writeFile };