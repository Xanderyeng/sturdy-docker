#!/usr/bin/env bash

sudo service apache2 reload > /dev/null 2>&1
sudo service php7.4-fpm reload > /dev/null 2>&1
sudo service php8.0-fpm reload > /dev/null 2>&1
sudo service php8.1-fpm reload > /dev/null 2>&1
