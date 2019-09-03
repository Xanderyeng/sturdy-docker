# Docker for WordPress
This is a [Docker](https://www.docker.com) based local environment for [WordPress](https://wordpress.org) Development

## Table of Content

1. [Overview](https://github.com/benlumia007/docker-for-wordpress#overview)
2. Requirements
3. Setup
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

## Shyaml for Linux ( Ubuntu / Elementary OS )
<pre>
sudo install python-pip
sudo pip install shyaml
</pre>

#How to Use
After you have successfully install shyaml, you can begin setting up before you docker up. The project uses Makefile that have specific commands that does automation for you so you don't need to do them manually. 

## Create Initial Setup
The initial setup will use the docker-setup.yml and duplicates to docker-custom.yml and by default sandbox.test is used. This will eventually generates a sandbox.conf using the nginx.tmpl template file and replaces the domain name and hostname and it uses upstream ( proxy ) to make your site available. The docker-custom.yml looks like this
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

After you have done all this above, is done to docker-compose up -d, this will then pull down all necesary iamges and deploy them. Please note that  it is using localhost of 127.0.0.1, therefore, using a custom domain will work fine, just go to the hosts file and type the following 
<pre>
127.0.0.1 sandbox.test
127.0.0.1 example.test
</pre>
