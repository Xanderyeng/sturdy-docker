const fs = require( 'fs-extra' );
const replace = require( 'replace-in-file' );
const { exec } = require( 'child_process' );
const { execSync } = require( 'child_process' );
const gateway = require( `./gateway` );
const path = require( `./configure` );
const getConfigPath = path.setConfigPath();
const getSitesPath = path.setSitesPath();
const getCertsPath = path.setCertsPath();


// Here, we are going to create a nginx conf file for dashboard
if ( ! fs.existsSync( `${getConfigPath}/nginx/dashboard.conf` ) ) {
    fs.copy( `${getConfigPath}/templates/nginx.conf`, `${getConfigPath}/nginx/dashboard.conf`, error => {
        if ( error ) {
            throw error;
        } else {
            const options = { files: `${getConfigPath}/nginx/dashboard.conf`, from: /{{DOMAIN}}/g, to: `dashboard` };
            replaced = replace.sync( options );
        }
    } );
}

// Here we are going to create a dashboard folder to host the dashboard's files
if ( ! fs.existsSync( `${getSitesPath}/dashboard/public_html` ) ) {
    fs.mkdir( `${getSitesPath}/dashboard/public_html`, { recursive: true }, error => {
        if ( error ) {
            throw error;
        }
    } );
}

// Here, we are going to grab files from GitHub for the dashboard.
if ( ! fs.existsSync( `${getSitesPath}/dashboard/public_html/.git` ) ) {
    exec( `git clone https://github.com/benlumia007/wsl-docker-dashboard.git ${getSitesPath}/dashboard/public_html` );
} else {
    exec( `git pull`, { cwd: `${getSitesPath}/dashboard/public_html` } );
}

// Here, we are going to create a certs for the dashboard, which also includes the root ca by default.
if ( ! fs.existsSync( `${getCertsPath}/ca/ca.crt` ) ) {
    fs.mkdir( `${getCertsPath}/ca`, { recursive: true }, error => {
        if ( error ) {
            throw error;
        } else {
            execSync( `openssl genrsa -out "${getCertsPath}/ca/ca.key" 4096`, {stdio: 'ignore' } );
            execSync( `openssl req -x509 -new -nodes -key "${getCertsPath}/ca/ca.key" -sha256 -days 365 -out "${getCertsPath}/ca/ca.crt" -subj "/CN=Docker for WordPress"`, { stdio: 'ignore' } );
        }
    } );
}

// Here, we are going to create certs for the dashboard.
if ( ! fs.existsSync( `${getCertsPath}/dashboard/dashboard.crt` ) ) {
    fs.mkdir( `${getCertsPath}/dashboard/`, { recursive: true }, error => {
        if ( error ) {
            throw error;
        } else {
            fs.copy( `${getConfigPath}/templates/certs.ext`, `${getCertsPath}/dashboard/dashboard.ext`, error => {
                if ( error ) {
                    throw error;
                } else {
                    execSync( `openssl genrsa -out "${getCertsPath}/dashboard/dashboard.key" 4096`, { stdio: 'ignore' } );
                    execSync( `openssl req -new -key "${getCertsPath}/dashboard/dashboard.key" -out "${getCertsPath}/dashboard/dashboard.csr" -subj "/CN=*.dashboard.test"` );
                    execSync( `openssl x509 -req -in "${getCertsPath}/dashboard/dashboard.csr" -CA "${getCertsPath}/ca/ca.crt" -CAkey "${getCertsPath}/ca/ca.key" -CAcreateserial -out "${getCertsPath}/dashboard/dashboard.crt" -days 365 -sha256 -extfile "${getCertsPath}/dashboard/dashboard.ext"` );
                }
            } );
        }
    } );
}