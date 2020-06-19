# WP 4 Docker
This is a [Docker](https://www.docker.com) based local environment for [WordPress](https://wordpress.org) developing using the new WSL2. 

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
Before you begin, I would like to point out one of the file that gets used often, and that file is <code>custom.yml</code> and when you docker up for the first time, it will then duplicate <code>default.yml</code> to <code>custom.yml</code> inside of the global folder and it will use that to generate any sites you want. By default, the only site that gets create is the dashboard and sandbox. You can manually copy the default.yml and copy to the .global folder and rename to custom.yml and start your process of creating your sites.
up. 
<pre>
sites:
  sandbox:
    provision: true
    repo: https://github.com/benlumia007/wp-4-docker-sites.git
    host:
      - sandbox.test
</pre>

## Certificates and phpMyAdmin
In the <code>docker-custom.yml</code> file, there is a section where you will see phpMyAdmin and TLS-CA, this is where any resources will go so that it will generated any resources that comes with. At this time, only phpMyAdmin and TLS-CA is included since the project itself will be using https rather than http for connection.

After you have done all this above, is done to docker-compose up -d, this will then pull down all necesary iamges and deploy them. Please note that the hosts file will be automatically updated when you first initial-setup for each site you create. 

## MySQL
By default, only the root is set, but the good thing is that when creating a WordPress site, it will then create a new user and password "wordpress" and it will then create a database if exists and will launched. 

## MailHog
You can now access MailHog

## Notes
Please note that it is not necessary to edit docker-compose.yml since everything is tied together and no changes are needed except for if you wish to use different php version, then you can make that change. Other than that, I would suggest that you do not edit or modify `docker-compose.yml` at all.