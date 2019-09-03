# Docker for WordPress
This is a [Docker](https://www.docker.com) based local environment for [WordPress](https://wordpress.org) Development

## Table of Content

1. Overview
2. Requirements
3. Setup
4.  MySQL
5. MailHog

## Prerequisite
Before you begin using Docker for WordPress, I like to point out a few things. Docker for WordPress currently works with Linux and macOS with the latest Docker for Mac and Docker CE for Linux which also comes with other software needed. The main piece of software that you will need since shyaml which is a tool that allows specific files to read and generate automation throughout the this project. Without shyaml, the automation will not work well and may not able to get it working.

## Installing Shyaml from Homebrew for macOS
<pre>
brew install shyaml
</pre>

## Installing Shyaml for Ubuntu or Elementary OS
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
