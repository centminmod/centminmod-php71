# Multiple PHP-FPM Versions For Centmin Mod LEMP

Testing [centminmod.com](https://centminmod.com) 123.09beta01+ and higher support for multiple PHP-FPM versions utilising [Remi Yum Repository's SCL](https://blog.remirepo.net/post/2017/05/11/PHP-version-7.0.19-and-7.1.5) `php71` version to work side by side concurrently with Centmin Mod's default PHP-FPM version. This Remi SCL based PHP 7.1 branch version will not be able to support advanced optimisations like Centmin Mod 123.09beta01's source compiled PHP 7.x versions which support optionally, [Profile Guide Optimisations](https://community.centminmod.com/threads/added-profile-guided-optimizations-to-boost-php-7-performance.8961/) to boost PHP 7 performance by another 3-17% ([benchmarks](https://community.centminmod.com/threads/addons-php71-sh-multiple-php-fpm-versions-work-preview.11900/#post-50643)) or Intel cpu specific optimised PHP compilations.

## Compare Centmin Mod PHP-FPM vs Remi SCL PHP-FPM

Benchmark comparison for [Centmin Mod 123.09beta01](https://centminmod.com/changelog.html#123eva200009) branch's PHP-FPM source installs with and without [Profile Guide Optimisations](https://community.centminmod.com/threads/added-profile-guided-optimizations-to-boost-php-7-performance.8961/).

System:

* OVH MC-32 Intel Core i7 4790K
* 32GB Memory
* 2x240GB SSD
* 250Mbit Network Bandwidth
* CentOS 7.4 64bit
* Centmin Mod 123.09beta01 LEMP stack - Nginx 1.13.8, MariaDB 10.1.30 MySQL, + CSF Firewall
* BHS, Canada

Only latest version from each major branch comparison

|PHP Version|bench.php|micro_bench.php|detailed_benchmark.php
|--- | --- |--- | ---
|PHP 7.2.0 GA centminmod php-fpm + PGO |0.3990|2.0607|1.7720
|PHP 7.2.0 GA centminmod php-fpm + no PGO |0.3903|2.1320|1.7677
|PHP 7.1.12 centminmod php-fpm + PGO|0.4003|2.1933|1.9350
|PHP 7.1.12 centminmod php-fpm + No PGO|0.4100|2.2593|1.9893
|PHP 7.0.26 centminmod php-fpm + PGO|0.4273|2.2353|2.0093
|PHP 7.0.26 centminmod php-fpm + No PGO|0.4267|2.2780|2.0137
|PHP 5.6.32 centminmod php-fpm |1.1580|5.5193|3.9357
|PHP 7.2.0 GA remi scl php-fpm|0.3807|2.2503|1.9110
|PHP 7.1.12 remi scl php-fpm |0.4097|2.3933|2.0787
|PHP 7.0.26 remi scl php-fpm |0.4347|2.2823|2.1303
|PHP 5.6.32 remi scl php-fpm |1.1537|5.7430|4.0240

Full comparison

|PHP Version|bench.php|micro_bench.php|detailed_benchmark.php
|--- | --- |--- | ---
|PHP 7.2.0 GA centminmod php-fpm + PGO |0.3990|2.0607|1.7720
|PHP 7.2.0 GA centminmod php-fpm + no PGO |0.3903|2.1320|1.7677
|PHP 7.2.0RC6 centminmod php-fpm + PGO |0.4167|2.0783|1.7640
|PHP 7.2.0RC6 centminmod php-fpm + no PGO |0.3910|2.1657|1.7593
|PHP 7.2.0RC5 centminmod php-fpm + PGO |0.3973|2.0800|1.7627
|PHP 7.2.0RC5 centminmod php-fpm + no PGO |0.3887|2.3317|1.7473
|PHP 7.2.0RC4 centminmod php-fpm + PGO |0.3953|2.0823|1.7677
|PHP 7.2.0RC4 centminmod php-fpm + no PGO |0.3973|2.2330|1.7973
|PHP 7.2.0RC3 centminmod php-fpm + PGO |0.4000|2.0760|1.7580
|PHP 7.2.0RC3 centminmod php-fpm + no PGO |0.3983|2.3100|1.7853
|PHP 7.2.0RC2 centminmod php-fpm + PGO |0.3987|2.0753|1.7690
|PHP 7.2.0RC2 centminmod php-fpm + no PGO |0.3967|2.3223|1.7670
|PHP 7.2.0RC1 centminmod php-fpm + PGO |0.3983|2.1357|1.7633
|PHP 7.2.0RC1 centminmod php-fpm + no PGO |0.3980|2.2853|1.7673
|PHP 7.2.0beta3 centminmod php-fpm + PGO |0.3833|2.0583|1.7590
|PHP 7.2.0beta3 centminmod php-fpm + no PGO |0.3903|2.3120|1.7643
|PHP 7.2.0beta2 centminmod php-fpm + PGO |0.3837|2.0617|1.7530
|PHP 7.2.0beta2 centminmod php-fpm + no PGO |0.4003|2.2843|1.7693
|PHP 7.2.0beta1 centminmod php-fpm + PGO |0.3877|2.0783|1.7167
|PHP 7.2.0beta1 centminmod php-fpm + no PGO |0.3890|2.2053|1.7843
|PHP 7.2.0alpha3 centminmod php-fpm + PGO |0.3850|2.0483|1.7543
|PHP 7.2.0alpha3 centminmod php-fpm + no PGO |0.3877|2.2887|1.7613
|PHP 7.2.0alpha2 centminmod php-fpm + PGO |0.3947|2.0503|1.7457
|PHP 7.2.0alpha2 centminmod php-fpm + No PGO|0.3973|2.1437|1.7540
|PHP 7.2.0alpha1 centminmod php-fpm + PGO|0.3852|2.1047|1.7820
|PHP 7.2.0alpha1 centminmod php-fpm + No PGO|0.3888|2.2572|1.7793
|PHP 7.1.12 centminmod php-fpm + PGO|0.4003|2.1933|1.9350
|PHP 7.1.12 centminmod php-fpm + No PGO|0.4100|2.2593|1.9893
|PHP 7.1.11 centminmod php-fpm + PGO|0.4177|2.3430|1.9313
|PHP 7.1.11 centminmod php-fpm + No PGO|0.4130|2.2530|1.9400
|PHP 7.1.10 centminmod php-fpm + PGO|0.4000|2.2017|1.9200
|PHP 7.1.10 centminmod php-fpm + No PGO|0.4110|2.2557|1.9667
|PHP 7.1.9 centminmod php-fpm + PGO|0.4013|2.1940|1.9543
|PHP 7.1.9 centminmod php-fpm + No PGO|0.4097|2.2133|1.9553
|PHP 7.1.8 centminmod php-fpm + PGO|0.4010|2.3073|1.9300
|PHP 7.1.8 centminmod php-fpm + No PGO|0.4110|2.2667|1.9477
|PHP 7.1.7 centminmod php-fpm + PGO|0.4093|2.3673|1.9413
|PHP 7.1.7 centminmod php-fpm + No PGO|0.4080|2.2580|1.9337
|PHP 7.1.6 centminmod php-fpm + No PGO|0.4069|2.2363|1.9149
|PHP 7.1.6 centminmod php-fpm + PGO|0.4135|2.2365|1.9436
|PHP 7.0.26 centminmod php-fpm + PGO|0.4273|2.2353|2.0093
|PHP 7.0.26 centminmod php-fpm + No PGO|0.4267|2.2780|2.0137
|PHP 7.0.25 centminmod php-fpm + PGO|0.4273|2.2577|1.9770
|PHP 7.0.25 centminmod php-fpm + No PGO|0.4300|2.3300|2.0140
|PHP 7.0.24 centminmod php-fpm + PGO|0.4303|2.2797|2.0413
|PHP 7.0.24 centminmod php-fpm + No PGO |0.4293|2.3350|2.0487
|PHP 7.0.23 centminmod php-fpm + PGO|0.4293|2.2430|2.0123
|PHP 7.0.23 centminmod php-fpm + No PGO |0.4353|2.2980|2.0250
|PHP 7.0.22 centminmod php-fpm + PGO|0.4260|2.2100|1.9900
|PHP 7.0.22 centminmod php-fpm + No PGO |0.4253|2.2490|2.0273
|PHP 7.0.21 centminmod php-fpm + PGO|0.4150|2.2337|2.0093
|PHP 7.0.21 centminmod php-fpm + No PGO|0.4280|2.2863|1.9980
|PHP 5.6.32 centminmod php-fpm |1.1580|5.5193|3.9357
|PHP 5.6.31 centminmod php-fpm |1.1470|5.5567|3.9703
|PHP 5.6.30 centminmod php-fpm |1.1510|5.6733|3.9657
|PHP 7.2.0 GA remi scl php-fpm|0.3807|2.2503|1.9110
|PHP 7.2.0RC6 remi scl php-fpm|0.3837|2.2277|1.9400
|PHP 7.2.0RC5 remi scl php-fpm|0.3880|2.3090|1.9210
|PHP 7.2.0RC4 remi scl php-fpm|0.3823|2.2780|1.9077
|PHP 7.2.0RC3 remi scl php-fpm||0.3867|2.1560|1.9073
|PHP 7.2.0RC2 remi scl php-fpm|0.3817|2.2230|1.9050
|PHP 7.2.0RC1 remi scl php-fpm|0.3863|2.1770|1.9057
|PHP 7.2.0beta3 remi scl php-fpm|0.3817|2.2200|1.9300
|PHP 7.2.0beta2 remi scl php-fpm |0.3887|2.1637|1.9317
|PHP 7.2.0beta1 remi scl php-fpm |0.3957|2.1917|1.9207
|PHP 7.2.0alpha3 remi scl php-fpm |0.3853|2.1760|1.9057
|PHP 7.2.0alpha2 remi scl php-fpm |0.3920|2.1953|1.9090
|PHP 7.2.0alpha1 remi scl php-fpm|0.3942|2.2707|1.9384
|PHP 7.1.12 remi scl php-fpm |0.4097|2.3933|2.0787
|PHP 7.1.11 remi scl php-fpm |0.4117|2.3860|2.0823
|PHP 7.1.10 remi scl php-fpm |0.4050|2.4053|2.0727
|PHP 7.1.9 remi scl php-fpm |0.4067|2.3673|2.1000
|PHP 7.1.8 remi scl php-fpm |0.4110|2.3637|2.1057
|PHP 7.1.7 remi scl php-fpm |0.4113|2.3783|2.1077
|PHP 7.1.6 remi scl php-fpm|0.4148|2.3908|2.0900
|PHP 7.0.26 remi scl php-fpm |0.4347|2.2823|2.1303
|PHP 7.0.25 remi scl php-fpm |0.4310|2.3513|2.0957
|PHP 7.0.24 remi scl php-fpm |0.4330|2.2923|2.0943
|PHP 7.0.23 remi scl php-fpm |0.4343|2.3023|2.0933
|PHP 7.0.22 remi scl php-fpm |0.4303|2.2987|2.1110
|PHP 7.0.21 remi scl php-fpm |0.4327|2.2907|2.1277
|PHP 7.0.20 remi scl php-fpm|0.4330|2.2682|2.1270
|PHP 5.6.32 remi scl php-fpm |1.1537|5.7430|4.0240
|PHP 5.6.31 remi scl php-fpm |1.1567|5.6847|4.0327
|PHP 5.6.30 remi scl php-fpm|1.2167|5.8848|4.1424

Blitz.io 1000 user load test from Virginia Region to OVH MC-32 BHS, Canada

|PHP Version|requests|requests/s|peak requests/s|requests/day|avg resp time|min resp time|max resp time
|--- | --- |--- | ---| --- |--- | --- | ---
|PHP 7.2.0alpha1 centminmod php-fpm + PGO|23047|384.12|580|33187680|215ms|115ms|654ms
|PHP 7.2.0alpha1 remi scl php-fpm|21968|366.13|541|31633920|260ms|115ms|809ms
|PHP 7.1.6 remi scl php-fpm|21687|361.45|527|31229280|273ms|116ms|845ms
|PHP 7.0.20 remi scl php-fpm|21886|364.77|531|31515840|264ms|116ms|819ms
|PHP 5.6.30 remi scl php-fpm|11192|186.53|219|16116480|1307ms|127ms|3238ms


## PHP 7.1

This PHP-FPM 7.1 branch version `php71.sh`:

* CentOS 7 transparent hugepages support is enabled for Zend Opcache if system detected to support it
* listens on port `9900` instead of `9000` with php-fpm pool named `php71-www`
* php-fpm status path = `/php71status`
* custom php.ini settings calculated by centmin mod are placed in `/etc/opt/remi/php71/php.d/zzz_customphp.ini`
* php config scan directory is at `/etc/opt/remi/php71/php.d`
* php-fpm config file at `/etc/opt/remi/php71/php-fpm.d/www.conf`
* error log at `/var/opt/remi/php71/log/php-fpm/www-error.log`
* centmin mod nginx's php include file is at `/usr/local/nginx/conf/php71-remi.conf` instead of default at `/usr/local/nginx/conf/php.conf` which you replace references to in your centmin mod nginx vhost config file
* `fpmconfphp71` is centmin mod command shortcut to invoke nano linux text editor to edit `/etc/opt/remi/php71/php-fpm.d/www.conf`
* `phpincphp71` is centmin mod command shortcut to invoke nano linux text editor to edit `/usr/local/nginx/conf/php71-remi.conf`
* `systemctl start php71-php-fpm` command to start php71-php-fpm service with command shortcut = `fpm71start`
* `systemctl restart php71-php-fpm` command to restart php71-php-fpm service with command shortcut = `fpm71restart`
* `systemctl stop php71-php-fpm` command to stop php71-php-fpm service with command shortcut = `fpm71stop`
* `systemctl status php71-php-fpm` command to get status for php71-php-fpm service with command shortcut = `fpm71status`

![](images/phpinfo-7.1.5-01.png)

## PHP 7.0

The PHP-FPM 7.0 branch version `php70.sh`:

* CentOS 7 transparent hugepages support is enabled for Zend Opcache if system detected to support it
* listens on port `9800` instead of `9000` with php-fpm pool named `php70-www`
* php-fpm status path = `/php70status`
* custom php.ini settings calculated by centmin mod are placed in `/etc/opt/remi/php70/php.d/zzz_customphp.ini`
* php config scan directory is at `/etc/opt/remi/php70/php.d`
* php-fpm config file at `/etc/opt/remi/php70/php-fpm.d/www.conf`
* error log at `/var/opt/remi/php70/log/php-fpm/www-error.log`
* centmin mod nginx's php include file is at `/usr/local/nginx/conf/php70-remi.conf` instead of default at `/usr/local/nginx/conf/php.conf` which you replace references to in your centmin mod nginx vhost config file
* `fpmconfphp70` is centmin mod command shortcut to invoke nano linux text editor to edit `/etc/opt/remi/php70/php-fpm.d/www.conf`
* `phpincphp70` is centmin mod command shortcut to invoke nano linux text editor to edit `/usr/local/nginx/conf/php70-remi.conf`
* `systemctl start php70-php-fpm` command to start php70-php-fpm service with command shortcut = `fpm70start`
* `systemctl restart php70-php-fpm` command to restart php70-php-fpm service with command shortcut = `fpm70restart`
* `systemctl stop php70-php-fpm` command to stop php70-php-fpm service with command shortcut = `fpm70stop`
* `systemctl status php70-php-fpm` command to get status for php70-php-fpm service with command shortcut = `fpm70status`

## PHP 5.6

The PHP-FPM 5.6 branch version `php56.sh` has slightly different paths compared to `php71.sh` and `php70.sh`:

* CentOS 7 transparent hugepages support for Zend Opcache is disabled as PHP <7 doesn't support it in Zend Opcache
* listens on port `9700` instead of `9000` with php-fpm pool named `php56-www`
* php-fpm status path = `/php56status`
* custom php.ini settings calculated by centmin mod are placed in `/opt/remi/php56/root/etc/php.d/zzz_customphp.ini`
* php config scan directory is at `/opt/remi/php56/root/etc/php.d`
* php-fpm config file at `/opt/remi/php56/root/etc/php-fpm.d/www.conf`
* error log at `/opt/remi/php56/root/var/log/php-fpm/www-error.log`
* centmin mod nginx's php include file is at `/usr/local/nginx/conf/php56-remi.conf` instead of default at `/usr/local/nginx/conf/php.conf` which you replace references to in your centmin mod nginx vhost config file
* `fpmconfphp56` is centmin mod command shortcut to invoke nano linux text editor to edit `/opt/remi/php56/root/etc/php-fpm.d/www.conf`
* `phpincphp56` is centmin mod command shortcut to invoke nano linux text editor to edit `/usr/local/nginx/conf/php56-remi.conf`
* `systemctl start php56-php-fpm` command to start php56-php-fpm service with command shortcut = `fpm56start`
* `systemctl restart php56-php-fpm` command to restart php56-php-fpm service with command shortcut = `fpm56restart`
* `systemctl stop php56-php-fpm` command to stop php56-php-fpm service with command shortcut = `fpm56stop`
* `systemctl status php56-php-fpm` command to get status for php56-php-fpm service with command shortcut = `fpm56status`

## PHP 7.2

This PHP-FPM 7.2 branch version `php72.sh`:

* Currently, following PHP extensions, json-post, mailparse, memcache and memcached aren't available yet in Remi SCL php72 YUM repo
* CentOS 7 transparent hugepages support is enabled for Zend Opcache if system detected to support it
* listens on port `10000` instead of `9000` with php-fpm pool named `php72-www`
* php-fpm status path = `/php72status`
* custom php.ini settings calculated by centmin mod are placed in `/etc/opt/remi/php72/php.d/zzz_customphp.ini`
* php config scan directory is at `/etc/opt/remi/php72/php.d`
* php-fpm config file at `/etc/opt/remi/php72/php-fpm.d/www.conf`
* error log at `/var/opt/remi/php72/log/php-fpm/www-error.log`
* centmin mod nginx's php include file is at `/usr/local/nginx/conf/php72-remi.conf` instead of default at `/usr/local/nginx/conf/php.conf` which you replace references to in your centmin mod nginx vhost config file
* `fpmconfphp72` is centmin mod command shortcut to invoke nano linux text editor to edit `/etc/opt/remi/php72/php-fpm.d/www.conf`
* `phpincphp72` is centmin mod command shortcut to invoke nano linux text editor to edit `/usr/local/nginx/conf/php72-remi.conf`
* `systemctl start php72-php-fpm` command to start php72-php-fpm service with command shortcut = `fpm72start`
* `systemctl restart php72-php-fpm` command to restart php72-php-fpm service with command shortcut = `fpm72restart`
* `systemctl stop php72-php-fpm` command to stop php72-php-fpm service with command shortcut = `fpm72stop`
* `systemctl status php72-php-fpm` command to get status for php72-php-fpm service with command shortcut = `fpm72status`

## PHP 7.3 Alpha

This PHP-FPM 7.3 branch version `php73.sh`:

* Currently, following PHP extensions, json-post, mailparse, memcache and memcached aren't available yet in Remi SCL php73 YUM repo
* CentOS 7 transparent hugepages support is enabled for Zend Opcache if system detected to support it
* listens on port `11000` instead of `9000` with php-fpm pool named `php73-www`
* php-fpm status path = `/php73status`
* custom php.ini settings calculated by centmin mod are placed in `/etc/opt/remi/php73/php.d/zzz_customphp.ini`
* php config scan directory is at `/etc/opt/remi/php73/php.d`
* php-fpm config file at `/etc/opt/remi/php73/php-fpm.d/www.conf`
* error log at `/var/opt/remi/php73/log/php-fpm/www-error.log`
* centmin mod nginx's php include file is at `/usr/local/nginx/conf/php73-remi.conf` instead of default at `/usr/local/nginx/conf/php.conf` which you replace references to in your centmin mod nginx vhost config file
* `fpmconfphp73` is centmin mod command shortcut to invoke nano linux text editor to edit `/etc/opt/remi/php73/php-fpm.d/www.conf`
* `phpincphp73` is centmin mod command shortcut to invoke nano linux text editor to edit `/usr/local/nginx/conf/php73-remi.conf`
* `systemctl start php73-php-fpm` command to start php73-php-fpm service with command shortcut = `fpm73start`
* `systemctl restart php73-php-fpm` command to restart php73-php-fpm service with command shortcut = `fpm73restart`
* `systemctl stop php73-php-fpm` command to stop php73-php-fpm service with command shortcut = `fpm73stop`
* `systemctl status php73-php-fpm` command to get status for php73-php-fpm service with command shortcut = `fpm73status`

PHP 7.3.0 Alpha1 still has yet to have compatible PHP extensions for the following Remi YUM packages:

* php73-php-pecl-geoip
* php73-php-pecl-igbinary
* php73-php-pecl-igbinary-devel
* php73-php-pecl-imagick
* php73-php-pecl-imagick-devel
* php73-php-pecl-json-post
* php73-php-pecl-mailparse
* php73-php-mcrypt
* php73-php-pecl-memcache
* php73-php-pecl-memcached
* php73-php-pecl-mysql
* php73-php-pecl-redis
* php73-php-pecl-zip

Installed PHP extensions include:

```
./php73.sh list

Installed Packages
php73.x86_64                       1.0-0.1.el7.remi            @remi
php73-php-bcmath.x86_64            7.3.0~alpha1-1.el7.remi     @remi
php73-php-devel.x86_64             7.3.0~alpha1-1.el7.remi     @remi
php73-php-embedded.x86_64          7.3.0~alpha1-1.el7.remi     @remi
php73-php-enchant.x86_64           7.3.0~alpha1-1.el7.remi     @remi
php73-php-fpm.x86_64               7.3.0~alpha1-1.el7.remi     @remi
php73-php-gd.x86_64                7.3.0~alpha1-1.el7.remi     @remi
php73-php-gmp.x86_64               7.3.0~alpha1-1.el7.remi     @remi
php73-php-imap.x86_64              7.3.0~alpha1-1.el7.remi     @remi
php73-php-intl.x86_64              7.3.0~alpha1-1.el7.remi     @remi
php73-php-ldap.x86_64              7.3.0~alpha1-1.el7.remi     @remi
php73-php-mbstring.x86_64          7.3.0~alpha1-1.el7.remi     @remi
php73-php-mysqlnd.x86_64           7.3.0~alpha1-1.el7.remi     @remi
php73-php-opcache.x86_64           7.3.0~alpha1-1.el7.remi     @remi
php73-php-pdo-dblib.x86_64         7.3.0~alpha1-1.el7.remi     @remi
php73-php-pspell.x86_64            7.3.0~alpha1-1.el7.remi     @remi
php73-php-snmp.x86_64              7.3.0~alpha1-1.el7.remi     @remi
php73-php-soap.x86_64              7.3.0~alpha1-1.el7.remi     @remi
php73-php-tidy.x86_64              7.3.0~alpha1-1.el7.remi     @remi
php73-php-xml.x86_64               7.3.0~alpha1-1.el7.remi     @remi
php73-php-xmlrpc.x86_64            7.3.0~alpha1-1.el7.remi     @remi
```

## Example

PHP version

```
php71 -v
PHP 7.1.5 (cli) (built: May  9 2017 17:04:23) ( NTS )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies
    with Zend OPcache v7.1.5, Copyright (c) 1999-2017, by Zend Technologies
```

Example for configuring Centmin Mod Nginx vhost to use this custom `php71` version at `/php71` location

```
location /php71 {
 include /usr/local/nginx/conf/php71-remi.conf;
}
```

Example for configuring Centmin Mod Nginx vhost to use this custom `php70` version at `/php70` location

```
location /php70 {
 include /usr/local/nginx/conf/php70-remi.conf;
}
```

Example for configuring Centmin Mod Nginx vhost to use this custom `php56` version at `/php56` location

```
location /php56 {
 include /usr/local/nginx/conf/php56-remi.conf;
}
```

process listing

```
./php71.sh process
root      6835  0.0  1.4 109280 26972 ?        Ss   14:18   0:00 nginx: master process /usr/local/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
nginx     6836  0.1  2.7 137952 52420 ?        S<   14:18   0:04  \_ nginx: worker process
nginx     6837  0.1  2.7 137952 52428 ?        S<   14:18   0:04  \_ nginx: worker process
nginx     6839  0.1  2.7 137952 52424 ?        S<   14:18   0:04  \_ nginx: worker process
root      6847  0.0  0.5 642156  9420 ?        Ss   14:18   0:00 php-fpm: master process (/usr/local/etc/php-fpm.conf)
root      7754  0.0  2.1 768576 40584 ?        Ss   15:15   0:00 php-fpm: master process (/etc/opt/remi/php71/php-fpm.conf)
nginx     7755  0.0  1.3 1145812 25220 ?       S    15:15   0:00  \_ php-fpm: pool php71-www
nginx     7756  0.0  0.5 768576 10952 ?        S    15:15   0:00  \_ php-fpm: pool php71-www
nginx     7757  0.0  0.5 768576 10952 ?        S    15:15   0:00  \_ php-fpm: pool php71-www
nginx     7758  0.0  0.5 768576 10952 ?        S    15:15   0:00  \_ php-fpm: pool php71-www
nginx     7759  0.0  0.5 768576 10956 ?        S    15:15   0:00  \_ php-fpm: pool php71-www
nginx     7760  0.0  0.5 768576 10956 ?        S    15:15   0:00  \_ php-fpm: pool php71-www
```

## Usage

    ./php71.sh 
    ./php71.sh {install|update|list|phpconfig|phperrors|phpcustom|phpslowlog|phpini|phpext|start|restart|stop|status|process}

```
./php71.sh status
● php71-php-fpm.service - The PHP FastCGI Process Manager
   Loaded: loaded (/usr/lib/systemd/system/php71-php-fpm.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2017-06-06 14:40:03 UTC; 19min ago
 Main PID: 7028 (php-fpm)
   Status: "Processes active: 0, idle: 5, Requests: 1, slow: 0, Traffic: 0req/sec"
   CGroup: /system.slice/php71-php-fpm.service
           ├─7028 php-fpm: master process (/etc/opt/remi/php71/php-fpm.conf)
           ├─7029 php-fpm: pool php71-www
           ├─7030 php-fpm: pool php71-www
           ├─7031 php-fpm: pool php71-www
           ├─7032 php-fpm: pool php71-www
           └─7033 php-fpm: pool php71-www

Jun 06 14:40:02 centos7.localdomain systemd[1]: Starting The PHP FastCGI Process Manager...
Jun 06 14:40:03 centos7.localdomain systemd[1]: Started The PHP FastCGI Process Manager.
```

```
./php71.sh phpconfig
Usage: /opt/remi/php71/root/usr/bin/php-config [OPTION]
Options:
  --prefix            [/opt/remi/php71/root/usr]
  --includes          [-I/opt/remi/php71/root/usr/include/php -I/opt/remi/php71/root/usr/include/php/main -I/opt/remi/php71/root/usr/include/php/TSRM -I/opt/remi/php71/root/usr/include/php/Zend -I/opt/remi/php71/root/usr/include/php/ext -I/opt/remi/php71/root/usr/include/php/ext/date/lib]
  --ldflags           []
  --libs              [-lcrypt   -lresolv -lcrypt -ledit -lncurses -lstdc++ -lz -lrt -lm -ldl -lnsl  -lxml2 -lz -lm -ldl -lgssapi_krb5 -lkrb5 -lk5crypto -lcom_err -lssl -lcrypto -lcrypt -lcrypt ]
  --extension-dir     [/opt/remi/php71/root/usr/lib64/php/modules]
  --include-dir       [/opt/remi/php71/root/usr/include/php]
  --man-dir           [/opt/remi/php71/root/usr/share/man]
  --php-binary        [/opt/remi/php71/root/usr/bin/php]
  --php-sapis         [apache2handler embed fpm  cli phpdbg cgi]
  --configure-options [--build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --program-prefix= --disable-dependency-tracking --prefix=/opt/remi/php71/root/usr --exec-prefix=/opt/remi/php71/root/usr --bindir=/opt/remi/php71/root/usr/bin --sbindir=/opt/remi/php71/root/usr/sbin --sysconfdir=/etc/opt/remi/php71 --datadir=/opt/remi/php71/root/usr/share --includedir=/opt/remi/php71/root/usr/include --libdir=/opt/remi/php71/root/usr/lib64 --libexecdir=/opt/remi/php71/root/usr/libexec --localstatedir=/var/opt/remi/php71 --sharedstatedir=/var/opt/remi/php71/lib --mandir=/opt/remi/php71/root/usr/share/man --infodir=/opt/remi/php71/root/usr/share/info --cache-file=../config.cache --with-libdir=lib64 --with-config-file-path=/etc/opt/remi/php71 --with-config-file-scan-dir=/etc/opt/remi/php71/php.d --disable-debug --with-pic --disable-rpath --without-pear --with-exec-dir=/opt/remi/php71/root/usr/bin --with-freetype-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr --enable-gd-native-ttf --without-gdbm --with-jpeg-dir=/usr --with-openssl --with-system-ciphers --with-zlib --with-layout=GNU --with-kerberos --with-libxml-dir=/usr --with-system-tzdata --with-mhash --enable-dtrace --libdir=/opt/remi/php71/root/usr/lib64/php --enable-pcntl --enable-opcache --enable-opcache-file --enable-phpdbg --with-imap=shared --with-imap-ssl --enable-mbstring=shared --enable-mbregex --with-gd=shared,/usr --with-gmp=shared --enable-calendar=shared --enable-bcmath=shared --with-bz2=shared --enable-ctype=shared --enable-dba=shared --with-db4=/usr --with-tcadb=/usr --enable-exif=shared --enable-ftp=shared --with-gettext=shared --with-iconv=shared --enable-sockets=shared --enable-tokenizer=shared --with-xmlrpc=shared --with-ldap=shared --with-ldap-sasl --enable-mysqlnd=shared --with-mysqli=shared,mysqlnd --with-mysql-sock=/var/lib/mysql/mysql.sock --with-oci8=shared,instantclient,/usr/lib64/oracle/12.1/client64/lib,12.1 --with-pdo-oci=shared,instantclient,/usr,12.1 --with-interbase=shared --with-pdo-firebird=shared --enable-dom=shared --with-pgsql=shared --enable-simplexml=shared --enable-xml=shared --enable-wddx=shared --with-snmp=shared,/usr --enable-soap=shared --with-xsl=shared,/usr --enable-xmlreader=shared --enable-xmlwriter=shared --with-curl=shared,/usr --enable-pdo=shared --with-pdo-odbc=shared,unixODBC,/usr --with-pdo-mysql=shared,mysqlnd --with-pdo-pgsql=shared,/usr --with-pdo-sqlite=shared,/usr --with-sqlite3=shared,/usr --enable-json=shared --without-readline --with-libedit --with-pspell=shared --enable-phar=shared --with-mcrypt=shared,/usr --with-tidy=shared,/usr --with-pdo-dblib=shared,/usr --enable-sysvmsg=shared --enable-sysvshm=shared --enable-sysvsem=shared --enable-shmop=shared --enable-posix=shared --with-unixODBC=shared,/usr --enable-intl=shared --with-icu-dir=/usr --with-enchant=shared,/usr --with-recode=shared,/usr --enable-fileinfo=shared build_alias=x86_64-redhat-linux-gnu host_alias=x86_64-redhat-linux-gnu CFLAGS=-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic -fno-strict-aliasing -Wno-pointer-sign CXXFLAGS=-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic]
  --version           [7.1.5]
  --vernum            [70105]
```

```
./php71.sh phpext
[PHP Modules]
bcmath
bz2
calendar
Core
ctype
curl
date
dom
enchant
exif
fileinfo
filter
ftp
gd
geoip
gettext
gmp
hash
iconv
igbinary
imagick
imap
intl
json
json_post
ldap
libxml
mailparse
mbstring
mcrypt
memcache
memcached
msgpack
mysql
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_dblib
pdo_mysql
pdo_sqlite
Phar
pspell
readline
redis
Reflection
session
SimpleXML
snmp
soap
sockets
SPL
sqlite3
standard
tidy
tokenizer
wddx
xml
xmlreader
xmlrpc
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```

```
./php71.sh phpini
Configuration File (php.ini) Path: /etc/opt/remi/php71
Loaded Configuration File:         /etc/opt/remi/php71/php.ini
Scan for additional .ini files in: /etc/opt/remi/php71/php.d
Additional .ini files parsed:      /etc/opt/remi/php71/php.d/10-opcache.ini,
/etc/opt/remi/php71/php.d/20-bcmath.ini,
/etc/opt/remi/php71/php.d/20-bz2.ini,
/etc/opt/remi/php71/php.d/20-calendar.ini,
/etc/opt/remi/php71/php.d/20-ctype.ini,
/etc/opt/remi/php71/php.d/20-curl.ini,
/etc/opt/remi/php71/php.d/20-dom.ini,
/etc/opt/remi/php71/php.d/20-enchant.ini,
/etc/opt/remi/php71/php.d/20-exif.ini,
/etc/opt/remi/php71/php.d/20-fileinfo.ini,
/etc/opt/remi/php71/php.d/20-ftp.ini,
/etc/opt/remi/php71/php.d/20-gd.ini,
/etc/opt/remi/php71/php.d/20-gettext.ini,
/etc/opt/remi/php71/php.d/20-gmp.ini,
/etc/opt/remi/php71/php.d/20-iconv.ini,
/etc/opt/remi/php71/php.d/20-imap.ini,
/etc/opt/remi/php71/php.d/20-intl.ini,
/etc/opt/remi/php71/php.d/20-json.ini,
/etc/opt/remi/php71/php.d/20-ldap.ini,
/etc/opt/remi/php71/php.d/20-mbstring.ini,
/etc/opt/remi/php71/php.d/20-mcrypt.ini,
/etc/opt/remi/php71/php.d/20-mysqlnd.ini,
/etc/opt/remi/php71/php.d/20-pdo.ini,
/etc/opt/remi/php71/php.d/20-phar.ini,
/etc/opt/remi/php71/php.d/20-pspell.ini,
/etc/opt/remi/php71/php.d/20-simplexml.ini,
/etc/opt/remi/php71/php.d/20-snmp.ini,
/etc/opt/remi/php71/php.d/20-soap.ini,
/etc/opt/remi/php71/php.d/20-sockets.ini,
/etc/opt/remi/php71/php.d/20-sqlite3.ini,
/etc/opt/remi/php71/php.d/20-tidy.ini,
/etc/opt/remi/php71/php.d/20-tokenizer.ini,
/etc/opt/remi/php71/php.d/20-xml.ini,
/etc/opt/remi/php71/php.d/20-xmlwriter.ini,
/etc/opt/remi/php71/php.d/20-xsl.ini,
/etc/opt/remi/php71/php.d/30-mysqli.ini,
/etc/opt/remi/php71/php.d/30-pdo_dblib.ini,
/etc/opt/remi/php71/php.d/30-pdo_mysql.ini,
/etc/opt/remi/php71/php.d/30-pdo_sqlite.ini,
/etc/opt/remi/php71/php.d/30-wddx.ini,
/etc/opt/remi/php71/php.d/30-xmlreader.ini,
/etc/opt/remi/php71/php.d/30-xmlrpc.ini,
/etc/opt/remi/php71/php.d/40-geoip.ini,
/etc/opt/remi/php71/php.d/40-igbinary.ini,
/etc/opt/remi/php71/php.d/40-imagick.ini,
/etc/opt/remi/php71/php.d/40-mailparse.ini,
/etc/opt/remi/php71/php.d/40-memcache.ini,
/etc/opt/remi/php71/php.d/40-msgpack.ini,
/etc/opt/remi/php71/php.d/40-zip.ini,
/etc/opt/remi/php71/php.d/50-json_post.ini,
/etc/opt/remi/php71/php.d/50-memcached.ini,
/etc/opt/remi/php71/php.d/50-mysql.ini,
/etc/opt/remi/php71/php.d/50-redis.ini,
/etc/opt/remi/php71/php.d/zzz_customphp.ini
```

```
./php71.sh list
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.aarnet.edu.au
 * epel: fedora.uberglobalmirror.com
 * extras: mirror.aarnet.edu.au
 * remi: mirror.innosol.asia
 * rpmforge: mirror.as24220.net
 * updates: centos.mirror.serversaustralia.com.au
Installed Packages
php71.x86_64                                                                                                             1.0-1.el7.remi                                                                                                              @remi
php71-php-bcmath.x86_64                                                                                                  7.1.5-1.el7.remi                                                                                                            @remi
php71-php-devel.x86_64                                                                                                   7.1.5-1.el7.remi                                                                                                            @remi
php71-php-enchant.x86_64                                                                                                 7.1.5-1.el7.remi                                                                                                            @remi
php71-php-fpm.x86_64                                                                                                     7.1.5-1.el7.remi                                                                                                            @remi
php71-php-gd.x86_64                                                                                                      7.1.5-1.el7.remi                                                                                                            @remi
php71-php-gmp.x86_64                                                                                                     7.1.5-1.el7.remi                                                                                                            @remi
php71-php-imap.x86_64                                                                                                    7.1.5-1.el7.remi                                                                                                            @remi
php71-php-intl.x86_64                                                                                                    7.1.5-1.el7.remi                                                                                                            @remi
php71-php-ldap.x86_64                                                                                                    7.1.5-1.el7.remi                                                                                                            @remi
php71-php-mbstring.x86_64                                                                                                7.1.5-1.el7.remi                                                                                                            @remi
php71-php-mcrypt.x86_64                                                                                                  7.1.5-1.el7.remi                                                                                                            @remi
php71-php-mysqlnd.x86_64                                                                                                 7.1.5-1.el7.remi                                                                                                            @remi
php71-php-opcache.x86_64                                                                                                 7.1.5-1.el7.remi                                                                                                            @remi
php71-php-pdo-dblib.x86_64                                                                                               7.1.5-1.el7.remi                                                                                                            @remi
php71-php-pecl-geoip.x86_64                                                                                              1.1.1-3.el7.remi                                                                                                            @remi
php71-php-pecl-igbinary.x86_64                                                                                           2.0.4-1.el7.remi                                                                                                            @remi
php71-php-pecl-igbinary-devel.x86_64                                                                                     2.0.4-1.el7.remi                                                                                                            @remi
php71-php-pecl-imagick.x86_64                                                                                            3.4.3-1.el7.remi                                                                                                            @remi
php71-php-pecl-imagick-devel.x86_64                                                                                      3.4.3-1.el7.remi                                                                                                            @remi
php71-php-pecl-json-post.x86_64                                                                                          1.0.1-6.el7.remi                                                                                                            @remi
php71-php-pecl-mailparse.x86_64                                                                                          3.0.2-1.el7.remi                                                                                                            @remi
php71-php-pecl-memcache.x86_64                                                                                           3.0.9-0.7.20161124gitdf7735e.el7.remi                                                                                       @remi
php71-php-pecl-memcached.x86_64                                                                                          3.0.3-1.el7.remi                                                                                                            @remi
php71-php-pecl-mysql.x86_64                                                                                              1.0.0-0.15.20160812git230a828.el7.remi                                                                                      @remi
php71-php-pecl-redis.x86_64                                                                                              3.1.2-1.el7.remi                                                                                                            @remi
php71-php-pecl-zip.x86_64                                                                                                1.14.0-1.el7.remi                                                                                                           @remi
php71-php-pspell.x86_64                                                                                                  7.1.5-1.el7.remi                                                                                                            @remi
php71-php-snmp.x86_64                                                                                                    7.1.5-1.el7.remi                                                                                                            @remi
php71-php-soap.x86_64                                                                                                    7.1.5-1.el7.remi                                                                                                            @remi
php71-php-tidy.x86_64                                                                                                    7.1.5-1.el7.remi                                                                                                            @remi
php71-php-xml.x86_64                                                                                                     7.1.5-1.el7.remi                                                                                                            @remi
php71-php-xmlrpc.x86_64                                                                                                  7.1.5-1.el7.remi                                                                                                            @remi
```

Example for php71.sh updating from PHP 7.1.5 to 7.1.6

```
./php71.sh update
```

```
php71 -v
PHP 7.1.6 (cli) (built: Jun  7 2017 11:02:48) ( NTS )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies
    with Zend OPcache v7.1.6, Copyright (c) 1999-2017, by Zend Technologies
```

Example for php70.sh updating from PHP 7.0.19 to 7.0.20

```
./php70.sh update
```

```
php70 -v
PHP 7.0.20 (cli) (built: Jun  7 2017 06:56:00) ( NTS )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2017 Zend Technologies
    with Zend OPcache v7.0.20, Copyright (c) 1999-2017, by Zend Technologies
```