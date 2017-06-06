# Multiple PHP-FPM Versions For Centmin Mod LEMP

Testing [centminmod.com](https://centminmod.com) 123.09beta01+ and higher support for multiple PHP-FPM versions utilising [Remi Yum Repository's SCL](https://blog.remirepo.net/post/2017/05/11/PHP-version-7.0.19-and-7.1.5) `php71` version to work side by side concurrently with Centmin Mod's default PHP-FPM version. This PHP-FPM 7.1 branch version:

* listens on port `9900` instead of `9000` with php-fpm pool named `php71-www`
* php config scan directory is at `/etc/opt/remi/php71/php.d`
* php-fpm config file at `/etc/opt/remi/php71/php-fpm.d/www.conf`
* error log at `/var/opt/remi/php71/log/php-fpm/www-error.log`
* centmin mod nginx's php include file is at `/usr/local/nginx/conf/php71-remi.conf` instead of default at `/usr/local/nginx/conf/php.conf` which you replace references to in your centmin mod nginx vhost config file
* `fpmconfphp71` is centmin mod command shortcut to invoke nano linux text editor to edit `/etc/opt/remi/php71/php-fpm.d/www.conf`
* `/usr/bin/phpincphp71` is centmin mod command shortcut to invoke nano linux text editor to edit `/usr/local/nginx/conf/php71-remi.conf`
* `systemctl start php71-php-fpm` command to start php71-php-fpm service
* `systemctl restart php71-php-fpm` command to restart php71-php-fpm service
* `systemctl stop php71-php-fpm` command to stop php71-php-fpm service
* `systemctl status php71-php-fpm` command to get status for php71-php-fpm service

![](images/phpinfo-7.1.5-01.png)

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

process listing

```
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
    ./php71.sh {install|update|list|phpconfig|phperrors|phpcustom|phpini|phpext|start|restart|stop|status}

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