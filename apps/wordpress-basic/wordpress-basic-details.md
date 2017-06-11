# Wordpress Demo Install Details

```
upload files to /home/nginx/domains/domain.com/public
vhost log files directory is /home/nginx/domains/domain.com/log
```

```
domain: http://domain.com
vhost conf file for domain.com created: /usr/local/nginx/conf/conf.d/domain.com.conf

domain: https://domain.com
vhost ssl conf file for domain.com created: /usr/local/nginx/conf/conf.d/domain.com.ssl.conf
```

```
/usr/local/nginx/conf/ssl_include.conf created
Self-signed SSL Certificate: /usr/local/nginx/conf/ssl/domain.com/domain.com.crt
SSL Private Key: /usr/local/nginx/conf/ssl/domain.com/domain.com.key
SSL CSR File: /usr/local/nginx/conf/ssl/domain.com/domain.com.csr
```

```
Wordpress domain: domain.com
Wordpress DB Name: wp4206978db_9407
Wordpress DB User: wpdb9407u4894
Wordpress DB Pass: wpdbsFsQFdauRq4Jzaj3p22039
Wordpress Admin User ID: 130439
Wordpress Admin User: zEomlrj7iOvYsJzKdN7UyqCm4gwp17516
Wordpress Admin Pass: zJ4xgurbMzoJFrUwps20805
Wordpress Admin Email: email@domain.com
Wordpress Admin Display Name: wpdemo-admin
```

# Manual Setup


## Setup MySQL Database

```
mysqladmin create wp4206978db_9407
mysql -e "CREATE USER wpdb9407u4894@'localhost' IDENTIFIED BY 'wpdbsFsQFdauRq4Jzaj3p22039';"
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON wp4206978db_9407.* TO wpdb9407u4894@'localhost'; FLUSH PRIVILEGES;"
```

## Setup Wordpress Nginx Vhost

```
vhostname=domain.com
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
```

## Setup Wordpress Nginx Vhost

Switching base Wordpress install from HTTP to HTTPS with self-signed SSL certificate

```
cd /home/nginx/domains/domain.com/public
wp option update home 'https://domain.com' --allow-root
wp option update siteurl 'https://domain.com' --allow-root
wp search-replace 'http://domain.com' 'https://domain.com' --skip-columns=guid --allow-root
```

Switch back from HTTPS to HTTP

```
cd /home/nginx/domains/domain.com/public
wp option update home 'http://domain.com' --allow-root
wp option update siteurl 'http://domain.com' --allow-root
wp search-replace 'https://domain.com' 'http://domain.com' --skip-columns=guid --allow-root
```

## Disable Centmin Mod 123.09beta01's installed Wordpress Plugins

```
/usr/local/src/centminmod/addons/wpcli.sh install
cd /home/nginx/domains/domain.com/public
wp plugin deactivate akismet --allow-root
wp plugin deactivate cache-enabler --allow-root
wp plugin deactivate cdn-enabler --allow-root
wp plugin deactivate disable-xml-rpc --allow-root
wp plugin deactivate optimus --allow-root
wp plugin deactivate sucuri-scanner --allow-root
wp plugin status --allow-root
```

## Remove Wordpress Install

```
echo y | mysqladmin drop wp4206978db_9407
sed -i '/127.0.0.1 domain.com/d' /etc/hosts
rm -rf /home/wpdemo-temp
rm -rf /usr/local/nginx/conf/conf.d/domain.com.conf
rm -rf /usr/local/nginx/conf/conf.d/domain.com.ssl.conf
rm -rf /usr/local/nginx/conf/ssl/domain.com
rm -rf /home/nginx/domains/domain.com
rm -rf /usr/local/nginx/conf/wpincludes/domain.com/wpsecure_domain.com.conf
rm -rf /usr/local/nginx/conf/wpincludes/domain.com/wpsupercache_domain.com.conf
rm -rf /usr/local/nginx/conf/wpincludes/domain.com/rediscache_domain.com.conf
rm -rf /usr/local/nginx/conf/wpincludes/domain.com/wpcacheenabler_domain.com.conf
nprestart
```