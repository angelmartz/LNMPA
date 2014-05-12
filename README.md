LNMPA [Apache/Nginx|MYSQL/MariaDB|PHP] Installer
========================

 Copyright (C) <2014>  MTimer (http://www.mtimer.cn)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


## Author：MTimer - LNMPA For !!**CentOS/RedHat***!! 

-- Inspired By NewEraCracker Server For Windows

    Support CentOS/RHEL 32bit/64bit
    Support multi versions of Apache/MYSQL/MariaDB/PHP
    Support switch versions of Apache/MYSQL/MariaDB/PHP  ── In next release
    BY default, Nginx + MYSQL 5.6 + PHP 5.3 will be installed.

    Note：PHP runs BY PHP-FPM excepting that in PHP 5.3 + Apache circumstance, PHP run as mod_php of Apache.

    It takes a lot of time to write this script. I hope it helps some people to manage VPS or even servers.
    In future release it can switch versions of any server like Apache/Nginx Mysql/MariaDB PHP
    Please reserve the CREDITS file when you share it with your firends.


## All files

 - /mtimer/       ——		 This directory contains all
 - 	   log/		    ——		 Save logs files
 -     node/		  ——		 git		-    Optional
 -     server/	  ——     Servers mysql/mariadb|httpd/nginx|php
 -     www/       ——     Website directory, including all virtualhost directory


Need help? Email: mtimercms@hotmail.com  Attach lnmpa_install.log

Website: http://www.mtimer.cn

Thanks to many friends

See CREDITS: http://www.mtimer.cn



## Start Using MTimer Server

  Run it as root [One line]:

<pre>

wget -c --tries=3 -O lnmpa-latest-en.sh http://mtimercms.oss.aliyuncs.com/LNMPA-shell/lnmpa-latest-en.sh;chmod 755 lnmpa-latest-en.sh;./lnmpa-latest-en.sh 2>&1|tee lnmpa_install.log

</pre>


  Press【Enter】 if you dont want to choose anything：

  		Nginx + MYSQL 5.6 + PHP 5.3 will be installed by default

  **REPEAT**：

  		PHP runs BY PHP-FPM excepting that in PHP 5.3 + Apache circumstance, PHP run as mod_php of Apache.



## How To Choose

<pre>

   Are u a customer of MTimer CMS ? [1]Yes or [2]No
      Did you buy MTimer CMS ?  Default no

   [1]China or [2]World wide ? 
      Where is your server located ?  Default world wide

   [1]Apache or [2]Nginx ? 
      Default Nginx

      If Apache:
      Apache 2.[4] or 2.[2] ? 
        Default Apache 2.2

    PHP 5.[3], PHP 5.[4] or PHP 5.[5] ? 
      Default PHP 5.3

    [1]MySQL or [2]MariaDB ? 
      Default MySQL

      If MySQL:
      MySQL 5.[1], MySQL 5.[5] or MySQL 5.[6] ? 
        Default MySQL 5.6

      If MariaDB:
      [1]MariaDB 5.3, [2]MariaDB 5.5 or [3]MariaDB 10.0 ? 
        Default MariaDB 10.0

    [1]Adminer or [2]Phpmyadmin ? 
      Default Adminer

    Auto fdisk [1]Yes or [2]No ? 
      Default No

      If Yes： - will mount all free disk to /mtimer1 /mtimer2 etc..
      Enter your disk name eg. sd [if sda,sdb...] , xv [if xva,xvb] : 
        if your disks name is sda,sdb then input sd     xva,xvb then input xv

</pre>




## SSH Control

<pre>

    service httpd (start | stop | reload | restart)
    service nginx (start | stop | reload | restart)
    service mysql (start | stop | reload | restart)
    service php-fpm (start | stop | reload | restart)
    service memcached (start | stop | reload | restart) 
      //OR specify memcache server:
       service memcached (start | stop | reload | restart) memcached_11211
      memcached's pidfile located @ /etc/memcached/pidfiles/

</pre>


## Details

<pre>

    /mtimer            ——     ALL
    -----log              ——     Logs location
      --nginx
      --httpd
      --php
      --mysql
      --mariadb
    -----server           ——     All kinds of Servers
      --nginx
        --conf
          --nginx.conf    ——     nginx configuration file
          --rewrite       ——     rewrite configuration files location
          --vhosts        ——     vhosts configuration files location
          --crons         ——     cron files location
      --httpd
        --conf            ——     httpd configuration files location
          --httpd.conf    ——     main configuration file
          --vhosts        ——     vhosts, eg. example.com.conf
        --conf.d          ——     other configuration files directory
                                    eg. mod_fastcgi.conf [Apache + php 4/5]
        --crons           ——     cron files location
      --php
        --etc             ——     PHP configuration files location
          --php-fpm.conf  ——     PHP-FPM configuration file
          --php.ini       ——     PHP configuration file
      --mysql
        Note：my.cnf located @ /etc/my.cnf
      --mariadb

    -----www              ——       *Websites Directory*, containg all websites
      --example.com       ——       Default website root directory
      --soft.example.com  ——       Another website root directory. 
                                    If Nginx, Fancyindex enabled by default.
      --phpmyadmin        ——       phpMyAdmin, Access via http://Yourdomain:7772/
      --adminer           ——       Adminer, Access via http://Yourdomain:7771/
</pre>



## Notes

<pre>

  1)
  For faster IO,/tmp/ is linked to /dev/shm/
  So **Do Not** put important stuff under /tmp/ since files may disappear


  httpd.pid
  nginx.pid
  mysql.pid
  mysql.sock
  php-fpm.pid  all located @ /tmp/ . These files may disappear but don't worry. It does not affect restart/stop/ servers


  2)
  Cron job? 
  $ crontab -e
  $ i
    Add
    If Apache：
    00 00 * * * /bin/bash /mtimer/server/httpd/crons/split_httpd_log.sh

    OR

    If Nginx:
    00 00 * * * /bin/bash /mtimer/server/nginx/crons/split_nginx_log.sh
  $ :wq


  3)
  If Apache + php 5.3, PHP runs by mode_php, so there is no php-fpm. To restart PHP, same as restarting Apache。  $ Service httpd restart


  4)
  **Sometimes** you need to reboot to use FTP service


  5)
  FTP & MySQL passwords in account.log

  
</pre>


## ---@@---


    --2014.05.10 Update to 3.0,
    --LNMP upgrade to LNMPA, name as MTimer Server
    --MariaDB joined in
    --Complete reconstruct
    --Add docs
    --In next release support switch versions of Apache/MYSQL/MariaDB/PHP
    --Some day it will support control servers via PHP - maybe

    --2013.07.17 Update to 2.0, 
    --Long time ago, who cares

    Author:MTimer
    Email:MTimercms@hotmail.com