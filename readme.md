# Docker for WordPress
This is a [Docker](https://www.docker.com) based local environment for [WordPress](https://wordpress.org) Development

## Table of Content

1. [Overview](https://github.com/benlumia007/docker-for-wordpress#overview)
2. [Requirements](https://github.com/benlumia007/docker-for-wordpress#requirements)
3. [Setup](https://github.com/benlumia007/docker-for-wordpress#setup)
3. [Getting Started](https://github.com/benlumia007/docker-for-wordpress#getting-started)
4. [MySQL](https://github.com/benlumia007/docker-for-wordpress#mysql)
5. [MailHog](https://github.com/benlumia007/docker-for-wordpress#mailhog)

## Overview
Docker for WordPress is a local development environment based on docker-compose. By default, instead of using localhost, the project uses https://dashboard.test for better experience and allows you to access phpMyAdmin, MailHog, docs and supports. The containers that are used in this project are custom built and will go through them one by one with a better understanding on how each work.

The following containers are use are:
* NGINX
* phpfpm
* MySQL
* phpMyAdmin
* MailHog
* WP-Cli

## Requirements
One of the biggest requirements overall is Docker for Linux and Docker for Mac and <code>shyaml</code>. [Shyaml](https://pypi.org/project/shyaml/) is a simple script that allows you to read to get access to a yaml or yml data in your shell scripts, which the project needs to generate sites when added. 

### Shyaml for macOS
The easiest way to install shyaml is to use [Homebrew](https://github.com/Homebrew/brew/) for macOS installation
<pre>
brew install shyaml
</pre>

### Shyaml for Linux ( Ubuntu / Elementary OS )
<pre>
sudo install python-pip
sudo pip install shyaml
</pre>

### Setting Up Your Host User Passwordless
One of the biggest thing that I found useful is to set your username password when you use sudo privileges and it works with Linux and macOS so that you can setup hosts file when running one of the script to add and remove hosts in the hosts file. Please follow the following to make your user passwordless
<pre>
sudo visudo
</pre>
Once you are in this file, scrolled all the way down and enter the following
<pre>
username  ALL=(ALL:ALL) NOPASSWD:ALL
</pre>
This is the same step if you were to create your own vagrant box and that's it, you can edit your hosts file automatically when using one of the scripts provided.

## Automation
The main objective of this project was to automate everything much as possible. So what exactly does it automate. The automation is used to create the following
* dashboard
* sites ( WordPress )
* TLS-CA ( SSL Certificates )
Makefile is used to create, automate and even start servers.
<pre>
make
</pre>

## Getting Started
Before you begin, I would like to point out one of the file that gets used often, and that file is <code>docker-setup.yml</code> and when you docker up for the first time, it will then duplicate <code>docker-setup.yml</code> to <code>docker-custom.yml</code> and it will use that to generate any sites you want. By default, the only site that gets create is sandbox.test
<pre>
sites:
  sandbox:
    provision: false
    host: sandbox.test
</pre>
To begin, all you will need to do is the following change the provision to true and
<pre>
make
</pre>

## Certificates and phpMyAdmin
In the <code>docker-custom.yml</code> file, there is a section where you will see phpMyAdmin and TLS-CA, this is where any resources will go so that it will generated any resources that comes with. At this time, only phpMyAdmin and TLS-CA is included since the project itself will be using https rather than http for connection.
<pre>
make
</pre>

After you have done all this above, is done to docker-compose up -d, this will then pull down all necesary iamges and deploy them. Please note that the hosts file will be automatically updated when you first initial-setup for each site you create. 

## MySQL
By default, only the root is set, but the good thing is that when creating a WordPress site, it will then create a new user and password "wordpress" and it will then create a database if exists and will launched. 

## MailHog
You can now access MailHog