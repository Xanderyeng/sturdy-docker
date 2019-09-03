# Docker for WordPress
This is a [Docker](https://www.docker.com) based local environment for [WordPress](https://wordpress.org) Development

## Table of Content

1. [Overview](https://github.com/benlumia007/docker-for-wordpress#overview)
2. [Requirements](https://github.com/benlumia007/docker-for-wordpress#requirements)
3. [Getting Started](https://github.com/benlumia007/docker-for-wordpress#getting-started)
4.  MySQL
5. MailHog

## Overview
Docker for WordPress is a local development environment based on docker-compose. By default, instead of using localhost, the project uses https://sandbox.test for better experience and allows you to add more sites if needed so you won't be stuck using localhost by default. The containers that are used in this project are custom built and will go through them one by one with a better understanding on how each work. 

## Requirements
One of the biggest requirements overall is Docker for Linux and Docker for Mac and has been tested thorough. There is one more requirement needed and that equirement is <code>shyaml</code>. [Shyaml](https://pypi.org/project/shyaml/) is a simple script that allows you to read to get access to a yaml or yml data in your shell scripts, which the project needs to generate sites when added. 

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

## Makefile ( A Somewhat Automation )
Makefile scripts are only for macOS and Linux and will not work with Windows. Windows is currently not supported at the moment. What are the main scripts that gets run.
<pre>
make initial-setup
make create-certificates
</pre>

## Getting Started
Before you begin, I would like to point out one of the file that gets used often, and that file is <code>docker-setup.yml</code> and when you docker up for the first time, it will then duplicate <code>docker-setup.yml</code> to <code>docker-custom.yml</code> and it will use that to generate any sites you want. By default, the only site that gets create is sandbox.test
<pre>
sites:
  sandbox:
    host: sandbox.test
</pre>
To begin, all you will need to do is the following
<pre>
make initial-setup
</pre>

## Create Certificates
This certs and keys should not be used for production, these are meant for only local and development only. Please install after generating the certs because, by default, https is used. 
<pre>
make create-certificates
</pre>

After you have done all this above, is done to docker-compose up -d, this will then pull down all necesary iamges and deploy them. Please note that the hosts file will be automatically updated when you first initial-setup for each site you create. 

## MySQL