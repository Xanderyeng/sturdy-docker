# Sturdy Docker
WP 4 Docker is a local development environment focuses on WordPress. It uses [Docker](https://docker.com) and WSL2 for development.

## Table of Content

1. [Overview](https://github.com/benlumia007/docker-for-wordpress#overview)
2. [Requirements](https://github.com/benlumia007/docker-for-wordpress#requirements)
3. [Getting Started](https://github.com/benlumia007/docker-for-wordpress#getting-started)
4. [MySQL](https://github.com/benlumia007/docker-for-wordpress#mysql)
5. [MailHog](https://github.com/benlumia007/docker-for-wordpress#mailhog)

## Overview
WP 4 Docker is an easy and automate local development environment for WordPress that works on Linux, macOS, and Windows 10 Home ( Version 2004 ) for WSL2.

## Requirements
* [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install), [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/), or [Linux](https://docs.docker.com/engine/install/)
* [WSL2](https://docs.microsoft.com/en-us/windows/wsl/), if you are on Windows 10 Home ( Version: 2004 )
* Ubuntu 18.04 or 20.04 from Microsoft Store within Windows 10 Home ( Version: 2004 )

## Getting Started
Before you begin, I would like to point out one of the file that gets used often, and that file is <code>custom.yml</code> and when you docker up for the first time, it will then duplicate <code>default.yml</code> to <code>custom.yml</code> inside of the global folder and it will use that to generate any sites you want. By default, the only site that gets create is the dashboard and sandbox.
<pre>
sites:
  classicpress:
    provision: true
    repo: https://github.com/benlumia007/sturdy-docker-sites.git
    host:
      - classicpress.test
    custom:
      type: ClassicPress
      plugins:
        - query-monitor
      constants:
        - DISALLOW_FILE_EDIT
        - WP_DEBUG
        - WP_DEBUG_DISPLAY

  wordpress:
    provision: true
    repo: https://github.com/benlumia007/sturdy-docker-sites.git
    host:
      - wordpress.test
    custom:
      type: WordPress
      plugins:
        - query-monitor
      constants:
        - DISALLOW_FILE_EDIT
        - WP_DEBUG
        - WP_DEBUG_DISPLAY
</pre>
## Supressing prompts for elevating privileges
To allow docker and wsl2 to automatically update the hosts file without asking for a sudo password, add one of the following snippets to a new sudoers file.

For Ubuntu and most Linux environments:

### Allow passwordless
The most easiest way to achieve powerless sudo is to add your user to the sudoers with no password and it works with Linux and macOS, by using sudo visudo.

<pre>username ALL=(ALL:ALL) NOPASSWD:ALL</pre>

### Windows: UAC Prompt
You can use cacls or icacls to grant your user account permanent write permission to the system's hosts file. You have to open an elevated command prompt; hold ❖ Win and press X, then choose "Command Prompt (Admin)"

<pre>
cacls %SYSTEMROOT%\system32\drivers\etc\hosts /E /G username:W 
</pre>

### How to Begin
To begin, use git to clone the repository to anywhere
<pre>
git clone https://github.com/benlumia007/wp-4-docker.git WordPress
</pre>
I would like to keep this simple so I'm going to clone the repository to a folder called WordPress and navigate to the folder
<pre>
cd WordPress
</pre>

### Using npm
You can now use npm to install wp-4-docker using the following
<pre>
npm install @benlumia007/wp-4-docker@1.0.1
</pre>

At this point, since all the volumes has been set already in the `docker-compose.yml` file, you don't need to do anything from here so to get started, please use the following command
</pre>
sudo npm -g install
sudo npm link
</pre>
You should now have some few options especially the following `wp4docker up, wp4docker start, wp4docker restart, wp4docker stop, and wp4docker down`. Let's go ahead and do a `wp4docker up`, this will bring up the docker up, if you haven't pull the images, it will do that first and it will create nginx, mysql, and mailhog.

Before you begin, you should always wait for between 5 to 10 seconds everytime when you either start, restart, or up due to mysql container needs to finished initializing or else the the included provision will fail. After you have waited, let's begin, 
<pre>
wp4docker provision
</pre>
This will provision setup, databases, dashboard, sites, resources, each will do their parts. After it finishes, make sure to restart the containers, but in reality, you should only need to restart the nginx container, all you need to do is `wp4docker restart nginx`, if you just do a `wp4docker restart nginx`, it will restart all three containers.

Please note for the sake of containers, you should not do `wp4docker up` or `wp4docker down` often, you should only use these if you need to change to a different container or something fail or screws up the containers. Mostly you should only use `wp4docker start`, `wp4docker restart`, or `wp4docker stop` as much as possible.

When you add new sites if necessary, just follow copy and paste one of the sites and modify it. Then you should do a `wp4docker provision` and `wp4docker restart nginx`.

## Certificates and phpMyAdmin
In the <code>custom.yml</code> file, there is a section where you will see phpMyAdmin and TLS-CA, this is where any resources will go so that it will generated any resources that comes with. At this time, only phpMyAdmin and TLS-CA is included since the project itself will be using https rather than http for connection.

As for the certificates, it will generate a root ca and the rest for sites. You should only need to install the ca.crt and it should be SSL ready. 

## MySQL
By default, only the root is set, but the good thing is that when creating a WordPress site, it will then create a new user and password "wordpress" and it will then create a database if exists and will launched.
<pre>
user = root
password = root

user = wordpress
passsword = wordpress

user = classicpress
passsword = classicpress
</pre>
When you create a new site, it will use wordpress by default, you can use both root or wordpress to login.

## MailHog
You can now access MailHog

## WordPress
<pre>
user = admin
password = password
</pre>

## ClassicPress
ClassicPress is now supported, to aactivate, use the following
<pre>
sites:
  classicpress:
    provision: true
    repo: https://github.com/benlumia007/wp-4-docker-sites.git
    host:
      - classicpress.test
    custom:
      cms_type: ClassicPress
</pre>
<pre>
user = admin
password = password
</pre>

## Custom
If you decide not to use WordPress or ClassicPress, you have a option to not install anything and just create a new empty site
<pre>
  example:
    provision: true
    repo: https://github.com/benlumia007/wp-4-docker-sites.git
    host:
      - example.test
    custom:
      cms_type: none
</pre>