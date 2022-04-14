#!/usr/bin/env bash

sudo service nginx restart > /dev/null 2>&1
sudo service php7.4-fpm restart > /dev/null 2>&1
sudo service php8.0-fpm restart > /dev/null 2>&1
sudo service php8.1-fpm restart > /dev/null 2>&1