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
### How to Begin
To begin, use git to clone the repository to anywhere
<pre>
git clone https://github.com/benlumia007/wp-4-docker.git WordPress
</pre>
I would like to keep this simple so I'm going to clone the repository to a folder called WordPress and navigate to the folder
<pre>
cd WordPress
</pre>
At this point, since all the volumes has been set already in the `docker-compose.yml` file, you don't need to do anything from here so to get started, please use the following command
</pre>
sudo npm -g install
</pre>
You should now have some few options especially the following `wp4docker up, wp4docker start, wpdocker restart, wp4docker stop, and wp4docker down`. Let's go ahead and do a `wp4docker up`, this will bring up the docker up, if you haven't pull the images, it will do that first and it will create apache, mysql, and mailhog.

Before you begin, you should always wait for between 5 to 10 seconds everytime when you either start, restart, or up due to mysql container needs to finished initializing or else the the included provision will fail. After you have waited, let's begin, 
<pre>
wp4docker provision
</pre>
This will provision setup, databases, dashboard, sites, resources, each will do their parts. After it finishes, make sure to restart the containers, but in reality, you should only need to restart the apache container, all you need to do is `wpdocker restart apache`, if you just do a `wp4docker restart`, it will restart all three containers.

Please note for the sake of containers, you should not do `wpdocker up` or `wpdocker down` often, you should only use these if you need to change to a different container or something fail or screws up the containers. Mostly you should only use `wp4docker start`, `wpdocker restart`, and `wpdocker stop` as much as possible.

## Certificates and phpMyAdmin
In the <code>docker-custom.yml</code> file, there is a section where you will see phpMyAdmin and TLS-CA, this is where any resources will go so that it will generated any resources that comes with. At this time, only phpMyAdmin and TLS-CA is included since the project itself will be using https rather than http for connection.

After you have done all this above, is done to docker-compose up -d, this will then pull down all necesary iamges and deploy them. Please note that the hosts file will be automatically updated when you first initial-setup for each site you create. 

## MySQL
By default, only the root is set, but the good thing is that when creating a WordPress site, it will then create a new user and password "wordpress" and it will then create a database if exists and will launched. 

## MailHog
You can now access MailHog

## Notes
Please note that it is not necessary to edit docker-compose.yml since everything is tied together and no changes are needed except for if you wish to use different php version, then you can make that change. Other than that, I would suggest that you do not edit or modify `docker-compose.yml` at all.