# WSL Docker
This is a [Docker](https://www.docker.com) based local environment for [WordPress](https://wordpress.org) developing using the new WSL2. 

## Table of Content

1. [Overview](https://github.com/benlumia007/docker-for-wordpress#overview)
2. [Requirements](https://github.com/benlumia007/docker-for-wordpress#requirements)
3. [Automation](https://github.com/benlumia007/docker-for-wordpress#automation)
3. [Getting Started](https://github.com/benlumia007/docker-for-wordpress#getting-started)
4. [MySQL](https://github.com/benlumia007/docker-for-wordpress#mysql)
5. [MailHog](https://github.com/benlumia007/docker-for-wordpress#mailhog)

## Overview
WSL Docker ( formerly Docker for WordPress ) is a local environment based on WSL2 and Docker for Desktop. 

## Requirements
* [Docker Desktop for Windows Home](https://www.docker.com/)
* [WSL2](https://docs.microsoft.com/en-us/windows/wsl/)

### Unzip for Ubuntu
Apparently for some odd reason, unzip is not part of the release so you may need to install it manually
<pre>
sudo apt install zip unzip
</pre>

## Automation
The main objective of this project was to automate everything much as possible. So what exactly does it automate. The automation is used to create the following
* dashboard
* sites ( WordPress )
* TLS-CA ( SSL Certificates )
Makefile is used to create, and automate. You can use `wsldocker provision` when you make change to the `docker-custom.yml` or if there's any changes to the dashboard that is not related in anyways, you will then get these updates automatically. `wsldocker provision` is your friendy command.

## Getting Started
Before you begin, I would like to point out one of the file that gets used often, and that file is <code>docker-setup.yml</code> and when you docker up for the first time, it will then duplicate <code>docker-setup.yml</code> to <code>docker-custom.yml</code> and it will use that to generate any sites you want. By default, the only site that gets create is the
dashboard.test. Please do remember that doing a provision first to complete the initial setup and you must do a `wsl-docker up`, before you add a new site due to containers may not 
up. 
<pre>
sites:
  provision: false
  domain:
    - sandbox
</pre>
To begin, all you will need to do is the following change the provision to true and

## Certificates and phpMyAdmin
In the <code>docker-custom.yml</code> file, there is a section where you will see phpMyAdmin and TLS-CA, this is where any resources will go so that it will generated any resources that comes with. At this time, only phpMyAdmin and TLS-CA is included since the project itself will be using https rather than http for connection.

After you have done all this above, is done to docker-compose up -d, this will then pull down all necesary iamges and deploy them. Please note that the hosts file will be automatically updated when you first initial-setup for each site you create. 

## MySQL
By default, only the root is set, but the good thing is that when creating a WordPress site, it will then create a new user and password "wordpress" and it will then create a database if exists and will launched. 

## MailHog
You can now access MailHog

## Notes
Please note that it is not necessary to edit docker-compose.yml since everything is tied together and no changes are needed except for if you wish to use different php version, then you can make that change. Other than that, I would suggest that you do not edit or modify `docker-compose.yml` at all.