const path = require( './configure' );
const getComposeFile = path.setComposeFile();
const { execSync } = require( 'child_process' );

execSync( `docker-compose -f ${getComposeFile} exec nginx sudo mysql -uroot -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'root';"`, { stdio: 'inherit' } );
execSync( `docker-compose -f ${getComposeFile} exec nginx sudo mysql -uroot -proot -e "FLUSH PRIVILEGES;"`, { stdio: 'inherit' } );

execSync( `bash scripts/hosts.sh` );
