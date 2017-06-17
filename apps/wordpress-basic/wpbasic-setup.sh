#!/bin/bash
###################################################################################
# from github.com/centminmod/centminmod-php71/blob/master/apps/wordpress-basic/wordpress-basic-details.md
###################################################################################
vhostname=domain.com

mysqladmin create wp4206978db_9407
mysql -e "CREATE USER wpdb9407u4894@'localhost' IDENTIFIED BY 'wpdbsFsQFdauRq4Jzaj3p22039';"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON wp4206978db_9407.* TO wpdb9407u4894@'localhost'; FLUSH PRIVILEGES;"

echo "127.0.0.1 $vhostname" >> /etc/hosts
mkdir -p /home/wpdemo-temp
mkdir -p /usr/local/nginx/conf/ssl/${vhostname}
mkdir -p /usr/local/nginx/conf/wpincludes/${vhostname}
cd /home/wpdemo-temp
wget https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/mysql/wp-database.zip
wget https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/public/public.zip
wget https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/ssl/domain.com/ssl.zip
wget -O /usr/local/nginx/conf/conf.d/domain.com.conf https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/conf.d/domain.com.conf
wget -O /usr/local/nginx/conf/conf.d/domain.com.ssl.conf https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/conf.d/domain.com.ssl.conf
wget -O /usr/local/nginx/conf/wpincludes/domain.com/wpsecure_domain.com.conf https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/conf/wpincludes/domain.com/wpsecure_domain.com.conf
wget -O /usr/local/nginx/conf/wpincludes/domain.com/wpsupercache_domain.com.conf https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/conf/wpincludes/domain.com/wpsupercache_domain.com.conf
wget -O /usr/local/nginx/conf/wpincludes/domain.com/rediscache_domain.com.conf https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/conf/wpincludes/domain.com/rediscache_domain.com.conf
wget -O /usr/local/nginx/conf/wpincludes/domain.com/wpcacheenabler_domain.com.conf https://github.com/centminmod/centminmod-php71/raw/master/apps/wordpress-basic/conf/wpincludes/domain.com/wpcacheenabler_domain.com.conf
ls -lah /usr/local/nginx/conf/conf.d/ | grep -w domain.com
ls -lah /usr/local/nginx/conf/wpincludes/domain.com
unzip wp-database.zip
mysql wp4206978db_9407 < /home/wpdemo-temp/wp-database.sql
unzip ssl.zip -d /usr/local/nginx/conf/ssl/domain.com
ls -lah /usr/local/nginx/conf/ssl/domain.com
umask 027
mkdir -p /home/nginx/domains/$vhostname/{public,private,log,backup}
umask 022
unzip public.zip -d /home/nginx/domains/$vhostname/public
chown -R nginx:nginx "/home/nginx/domains/$vhostname"
find "/home/nginx/domains/$vhostname" -type d -exec chmod g+s {} \;
ls -lah /home/nginx/domains/$vhostname/public
nginx -t
nprestart
curl -sI http://domain.com