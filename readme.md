# Sturdy Docker
Sturdy Docker is a local development environment focuses on ClassicPress and WordPress and PHP applications.

## Table of Content

1. [Overview](https://github.com/benlumia007/docker-for-wordpress#overview)
2. [Requirements](https://github.com/benlumia007/docker-for-wordpress#requirements)
3. [Getting Started](https://github.com/benlumia007/docker-for-wordpress#getting-started)
4. [How to Begin](https://github.com/benlumia007/sturdy-docker#how-to-begin)
5. [Resources](https://github.com/benlumia007/sturdy-docker#resources)

## Overview
Sturdy Docker is an easy and automate local development environment for ClassicPress, WordPress and PHP applications that works on Linux, macOS, and Windows 10 with Windows Subsystem Linux 2.

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

## How to Begin
To begin, use git to clone the repository to anywhere
<pre>
git clone git@github.com:benlumia007/sturdy-docker.git WordPress
</pre>
I would like to keep this simple so I'm going to clone the repository to a folder called WordPress and navigate to the folder
<pre>
cd WordPress
</pre>

At this point, since all the volumes has been set already in the `docker-compose.yml` file, you don't need to do anything from here so to get started, please use the following command
<pre>
sudo npm install
sudo npm link
</pre>
You should now have some few options by typing `sturdydocker -v` or `sturdydocker --version` and you will see the following options
<pre>
Usage: sturdydocker [command]

Commands:

provision   Creae new WordPress site or sites
restart     Restarts one or more container
shell       Opens a shell for a specific container
start       Starts one or more container
stop        Stops one or more container
up          Starts one or more container
down        Destroys one or more container
pull        Pull image or images
logs        Fetch the logs of a container

Run 'sturdydocker [command] help' for more information on a command.
</pre>
The first thing you want to do is `sturdydocker pull` to pull the main image `benlumia007/sturdy-docker` or you can just do a `sturdydocker up` to automatically pull down the image needed.

### Provision
Let's begin provisioning by using the command `sturdydocker provision`. This will provision the following
<pre>
- dashboard
- sites
- resources
  - phpmyadmin
  - tls-ca 
</pre>

## Resources
In the <code>custom.yml</code> file, there is a section where you will see 
<pre>
resources:
  - phpmyadmin
  - tls-ca
</pre>
This is where any resources will go so that it will generated any resources that comes with. At this time, only phpMyAdmin and TLS-CA is included since the project itself will be using https rather than http for connection. As for the certificates, it will generate a root ca and the rest for sites. You should only need to install the ca.crt and it should be SSL ready. 

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
sites:
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
    repo: https://github.com/benlumia007/sturdy-docker-sites.git
    host:
      - example.test
    custom:
      type: none
</pre>