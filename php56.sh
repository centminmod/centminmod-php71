#/bin/bash
############################################
# centminmod.com multiple PHP-FPM version
# installer for PHP 5.6 branch installed
# side by side concurrently with default
# centmin mod installed PHP version using
# using Remi YUM repo's SCL php56 version
# written by George Liu centminmod.com
############################################
DT=$(date +"%d%m%y-%H%M%S")
CENTMINLOGDIR='/root/centminlogs'
repoopt='--disableplugin=priorities --disableexcludes=main,remi --enablerepo=remi,remi-test'
packages='php56 php56-php-fpm php56-php-devel php56-php-embedded php56-php-mysqlnd php56-php-bcmath php56-php-enchant php56-php-gd php56-php-pecl-geoip php56-php-gmp php56-php-pecl-igbinary php56-php-pecl-igbinary-devel php56-php-pecl-imagick php56-php-pecl-imagick-devel php56-php-imap php56-php-intl php56-php-pecl-json-post php56-php-ldap php56-php-pecl-mailparse php56-php-mbstring php56-php-mcrypt php56-php-pecl-memcache php56-php-pecl-memcached php56-php-pspell php56-php-pecl-redis php56-php-snmp php56-php-soap php56-php-tidy php56-php-xml php56-php-xmlrpc php56-php-pecl-zip php56-php-opcache'

############################################
# set locale temporarily to english
# due to some non-english locale issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

shopt -s expand_aliases
for g in "" e f; do
    alias ${g}grep="LC_ALL=C ${g}grep"  # speed-up grep, egrep, fgrep
done

if [[ "$(uname -m)" != 'x86_64' ]]; then
  echo
  echo "64bit Only"
  echo "aborting..."
  echo
  exit
fi

CENTOSVER=$(awk '{ print $3 }' /etc/redhat-release)

if [ ! -d "$CENTMINLOGDIR" ]; then
  mkdir -p "$CENTMINLOGDIR"
fi

if [ "$CENTOSVER" == 'release' ]; then
    CENTOSVER=$(awk '{ print $4 }' /etc/redhat-release | cut -d . -f1,2)
    if [[ "$(cat /etc/redhat-release | awk '{ print $4 }' | cut -d . -f1)" = '7' ]]; then
        CENTOS_SEVEN='7'
    fi
fi

if [[ "$(cat /etc/redhat-release | awk '{ print $3 }' | cut -d . -f1)" = '6' ]]; then
    CENTOS_SIX='6'
fi

if [ "$CENTOSVER" == 'Enterprise' ]; then
    CENTOSVER=$(cat /etc/redhat-release | awk '{ print $7 }')
    OLS='y'
fi

if [[ -f /etc/system-release && "$(awk '{print $1,$2,$3}' /etc/system-release)" = 'Amazon Linux AMI' ]]; then
    CENTOS_SIX='6'
fi

if [[ "$CENTOS_SEVEN" -ne '7' ]]; then
  echo
  echo "CentOS 7 Only"
  echo "aborting..."
  echo
  exit
fi

if [ ! -f /etc/yum.repos.d/remi.repo ]; then
  echo
  echo "Requires Remi Yum Repository"
  echo "aborting..."
  echo
  exit
fi

opcachehugepages() {
  # check if redis installed as redis server requires huge pages disabled
  if [[ -f /usr/bin/redis-cli ]]; then
    if [[ -f /sys/kernel/mm/transparent_hugepage/enabled ]]; then
      echo never > /sys/kernel/mm/transparent_hugepage/enabled
      if [[ -z "$(grep transparent_hugepage /etc/rc.local)" ]]; then
        echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
      fi
    fi
  fi

  # https://www.kernel.org/doc/Documentation/vm/transhuge.txt
  # only enable PHP zend opcache opcache.huge_code_pages=1 support if on CentOS 7.x and kernel
  # supports transparent hugepages. Otherwise, disable it in PHP zend opcache
  if [[ -f /sys/kernel/mm/transparent_hugepage/enabled ]]; then
    # cat /sys/kernel/mm/transparent_hugepage/enabled
    HP_CHECK=$(cat /sys/kernel/mm/transparent_hugepage/enabled | grep -o '\[.*\]')
    if [[ "$CENTOS_SIX" = '6' ]]; then
      if [ -f "${CONFIGSCANDIR}/20-opcache.ini" ]; then
        OPCACHEHUGEPAGES_OPT=''
        echo $OPCACHEHUGEPAGES_OPT
        if [[ "$(grep 'opcache.huge_code_pages' ${CONFIGSCANDIR}/20-opcache.ini)" ]]; then
          sed -i 's|^opcache.huge_code_pages=1|opcache.huge_code_pages=0|' ${CONFIGSCANDIR}/20-opcache.ini
          sed -i 's|^;opcache.huge_code_pages=1|opcache.huge_code_pages=0|' ${CONFIGSCANDIR}/20-opcache.ini
        else
          echo -e "\nopcache.huge_code_pages=0" >> ${CONFIGSCANDIR}/20-opcache.ini
        fi
      fi      
    elif [[ "$CENTOS_SEVEN" = '7' && "$HP_CHECK" = '[always]' ]]; then
      if [ -f "${CONFIGSCANDIR}/20-opcache.ini" ]; then
        OPCACHEHUGEPAGES_OPT=' --enable-huge-code-pages'
        echo $OPCACHEHUGEPAGES_OPT
        if [ -f "../tools/hptweaks.sh" ]; then
          ../tools/hptweaks.sh
        fi
        if [[ "$(grep 'opcache.huge_code_pages' ${CONFIGSCANDIR}/20-opcache.ini)" ]]; then
          sed -i 's|^;opcache.huge_code_pages=1|opcache.huge_code_pages=1|' ${CONFIGSCANDIR}/20-opcache.ini
        else
          echo -e "\nopcache.huge_code_pages=1" >> ${CONFIGSCANDIR}/20-opcache.ini
        fi
      fi
    elif [[ "$CENTOS_SEVEN" = '7' && "$HP_CHECK" = '[never]' ]]; then
      if [ -f "${CONFIGSCANDIR}/20-opcache.ini" ]; then
        OPCACHEHUGEPAGES_OPT=''
        echo $OPCACHEHUGEPAGES_OPT
        if [[ "$(grep 'opcache.huge_code_pages' ${CONFIGSCANDIR}/20-opcache.ini)" ]]; then
          sed -i 's|^opcache.huge_code_pages=1|opcache.huge_code_pages=0|' ${CONFIGSCANDIR}/20-opcache.ini
          sed -i 's|^;opcache.huge_code_pages=1|opcache.huge_code_pages=0|' ${CONFIGSCANDIR}/20-opcache.ini
        else
          echo -e "\nopcache.huge_code_pages=0" >> ${CONFIGSCANDIR}/20-opcache.ini
        fi
      fi        
    fi
  else
    if [ -f "${CONFIGSCANDIR}/20-opcache.ini" ]; then
      if [[ "$(grep 'opcache.huge_code_pages' ${CONFIGSCANDIR}/20-opcache.ini)" ]]; then
        sed -i 's|^opcache.huge_code_pages=1|opcache.huge_code_pages=0|' ${CONFIGSCANDIR}/20-opcache.ini
        sed -i 's|^;opcache.huge_code_pages=1|opcache.huge_code_pages=0|' ${CONFIGSCANDIR}/20-opcache.ini
      else
        echo -e "\nopcache.huge_code_pages=0" >> ${CONFIGSCANDIR}/20-opcache.ini
      fi    
    fi
  fi
}

phpsededit() {
    TOTALMEM=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    PHPINICUSTOM='zzz_customphp.ini'
    CONFIGSCANDIR='/opt/remi/php56/root/etc/php.d'
    CUSTOMPHPINIFILE="${CONFIGSCANDIR}/${PHPINICUSTOM}"

    if [[ ! -f "${CUSTOMPHPINIFILE}" ]]; then
        touch ${CUSTOMPHPINIFILE}
    else
        \cp -a ${CUSTOMPHPINIFILE} ${CUSTOMPHPINIFILE}-bak_$DT
        rm -rf $CUSTOMPHPINIFILE
        rm -rf ${CONFIGSCANDIR}/custom_php.ini
        echo "" > ${CUSTOMPHPINIFILE}
    fi

    if [[ "$(date +"%Z")" = 'EST' ]]; then
        echo "date.timezone = Australia/Brisbane" >> ${CUSTOMPHPINIFILE}
    else
        echo "date.timezone = UTC" >> ${CUSTOMPHPINIFILE}
    fi

    # dynamic PHP memory_limit calculation
    if [[ "$TOTALMEM" -le '262144' ]]; then
        ZOLIMIT='32'
        PHP_MEMORYLIMIT='48M'
        PHP_UPLOADLIMIT='48M'
        PHP_REALPATHLIMIT='256k'
        PHP_REALPATHTTL='14400'
    elif [[ "$TOTALMEM" -gt '262144' && "$TOTALMEM" -le '393216' ]]; then
        ZOLIMIT='80'
        PHP_MEMORYLIMIT='96M'
        PHP_UPLOADLIMIT='96M'
        PHP_REALPATHLIMIT='320k'
        PHP_REALPATHTTL='21600'
    elif [[ "$TOTALMEM" -gt '393216' && "$TOTALMEM" -le '524288' ]]; then
        ZOLIMIT='112'
        PHP_MEMORYLIMIT='128M'
        PHP_UPLOADLIMIT='128M'
        PHP_REALPATHLIMIT='384k'
        PHP_REALPATHTTL='28800'
    elif [[ "$TOTALMEM" -gt '524288' && "$TOTALMEM" -le '1049576' ]]; then
        ZOLIMIT='144'
        PHP_MEMORYLIMIT='160M'
        PHP_UPLOADLIMIT='160M'
        PHP_REALPATHLIMIT='384k'
        PHP_REALPATHTTL='28800'
    elif [[ "$TOTALMEM" -gt '1049576' && "$TOTALMEM" -le '2097152' ]]; then
        ZOLIMIT='240'
        PHP_MEMORYLIMIT='320M'
        PHP_UPLOADLIMIT='320M'
        PHP_REALPATHLIMIT='384k'
        PHP_REALPATHTTL='28800'
    elif [[ "$TOTALMEM" -gt '2097152' && "$TOTALMEM" -le '3145728' ]]; then
        ZOLIMIT='304'
        PHP_MEMORYLIMIT='384M'
        PHP_UPLOADLIMIT='384M'
        PHP_REALPATHLIMIT='512k'
        PHP_REALPATHTTL='43200'
    elif [[ "$TOTALMEM" -gt '3145728' && "$TOTALMEM" -le '4194304' ]]; then
        ZOLIMIT='496'
        PHP_MEMORYLIMIT='512M'
        PHP_UPLOADLIMIT='512M'
        PHP_REALPATHLIMIT='512k'
        PHP_REALPATHTTL='43200'
    elif [[ "$TOTALMEM" -gt '4194304' ]]; then
        ZOLIMIT='784'
        PHP_MEMORYLIMIT='800M'
        PHP_UPLOADLIMIT='800M'
        PHP_REALPATHLIMIT='640k'
        PHP_REALPATHTTL='86400'
    fi

    echo "max_execution_time = 60" >> ${CUSTOMPHPINIFILE}
    echo "short_open_tag = On" >> ${CUSTOMPHPINIFILE}
    echo "realpath_cache_size = $PHP_REALPATHLIMIT" >> ${CUSTOMPHPINIFILE}
    echo "realpath_cache_ttl = $PHP_REALPATHTTL" >> ${CUSTOMPHPINIFILE}
    echo "upload_max_filesize = $PHP_UPLOADLIMIT" >> ${CUSTOMPHPINIFILE}
    echo "memory_limit = $PHP_MEMORYLIMIT" >> ${CUSTOMPHPINIFILE}
    echo "post_max_size = $PHP_UPLOADLIMIT" >> ${CUSTOMPHPINIFILE}
    echo "expose_php = Off" >> ${CUSTOMPHPINIFILE}
    echo "mail.add_x_header = Off" >> ${CUSTOMPHPINIFILE}
    echo "max_input_nesting_level = 128" >> ${CUSTOMPHPINIFILE}
    echo "max_input_vars = 10000" >> ${CUSTOMPHPINIFILE}
    echo "mysqlnd.net_cmd_buffer_size = 16384" >> ${CUSTOMPHPINIFILE}
    echo "always_populate_raw_post_data=-1" >> ${CUSTOMPHPINIFILE}
    if [ ! -f "${CONFIGSCANDIR}/20-opcache.ini" ]; then
      echo "opcache.memory_consumption=$ZOLIMIT" > "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.interned_strings_buffer=8" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.max_wasted_percentage=5" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.max_accelerated_files=24000" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "; http://php.net/manual/en/opcache.configuration.php#ini.opcache.revalidate-freq" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "; defaults to zend opcache checking every 180 seconds for PHP file changes" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "; set to zero to check every second if you are doing alot of frequent" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "; php file edits/developer work" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "; opcache.revalidate_freq=0" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.revalidate_freq=180" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.fast_shutdown=0" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.enable_cli=0" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.save_comments=1" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.enable_file_override=1" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo "opcache.validate_timestamps=1" >> "${CONFIGSCANDIR}/20-opcache.ini"
      echo ";opcache.huge_code_pages=1" >> "${CONFIGSCANDIR}/20-opcache.ini"
    fi
    if [ -f "${CONFIGSCANDIR}/20-opcache.ini" ]; then
      sed -i "s|opcache.memory_consumption=.*|opcache.memory_consumption=$ZOLIMIT|" "${CONFIGSCANDIR}/20-opcache.ini"
    fi
    # opcachehugepages
    if [ -f /opt/remi/php56/root/etc/php-fpm.d/www.conf ]; then
      sed -i 's|pm.max_children = .*|pm.max_children = 20|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
      sed -i 's|pm.max_spare_servers = .*|pm.max_spare_servers = 15|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
    fi
}

phpinstall() {
  yum -y install $packages $repoopt
  phpsededit
  if [ ! -f /opt/remi/php56/root/var/log/php-fpm/www-error.log ]; then
    touch /opt/remi/php56/root/var/log/php-fpm/www-error.log
    chmod 0666 /opt/remi/php56/root/var/log/php-fpm/www-error.log
    chown nginx:nginx /opt/remi/php56/root/var/log/php-fpm/www-error.log
  fi
  if [ ! -f /opt/remi/php56/root/var/log/php-fpm/www-slow.log ]; then
    touch /opt/remi/php56/root/var/log/php-fpm/www-slow.log
    chmod 0666 /opt/remi/php56/root/var/log/php-fpm/www-slow.log
    chown nginx:nginx /opt/remi/php56/root/var/log/php-fpm/www-slow.log
  fi
  echo "systemctl stop php56-php-fpm" >/usr/bin/fpm56stop ; chmod 560 /usr/bin/fpm56stop
  echo "systemctl start php56-php-fpm" >/usr/bin/fpm56start ; chmod 560 /usr/bin/fpm56start
  echo "systemctl restart php56-php-fpm" >/usr/bin/fpm56restart ; chmod 560 /usr/bin/fpm56restart
  echo "systemctl reload php56-php-fpm" >/usr/bin/fpm56reload ; chmod 560 /usr/bin/fpm56reload
  echo "systemctl status php56-php-fpm" >/usr/bin/fpm56status ; chmod 560 /usr/bin/fpm56status
  echo "nano -w /opt/remi/php56/root/etc/php-fpm.d/www.conf" >/usr/bin/fpmconfphp56 ; chmod 560 /usr/bin/fpmconfphp56
  echo "nano -w /usr/local/nginx/conf/php56-remi.conf" >/usr/bin/phpincphp56 ; chmod 560 /usr/bin/phpincphp56
  cp -a /usr/local/nginx/conf/php.conf /usr/local/nginx/conf/php56-remi.conf
  sed -i 's|\[www\]|\[php56-www\]|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|9000|9700|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|9000|9700|' /usr/local/nginx/conf/php56-remi.conf
  sed -i 's|;listen.backlog = .*|;listen.backlog = 511|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|;listen.owner = .*|listen.owner = nginx|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|;listen.group = .*|listen.group = nginx|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|user = apache|user = nginx|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|group = apache|group = nginx|' /opt/remi/php56/root/etc/php-fpm.d/www.conf
  sed -i 's|;pm.status_path = \/status|pm.status_path = \/php56status|' /opt/remi/php56/root/etc/php-fpm.d/www.conf

  echo
  echo "start php56-php-fpm service"
  systemctl start php56-php-fpm
  systemctl enable php56-php-fpm
  echo
  echo "status php56-php-fpm service"
  systemctl status php56-php-fpm
  echo
  echo "command shortcuts"
  echo "phpincphp56 - edit /usr/local/nginx/conf/php56-remi.conf include file"
  echo "fpmconfphp56 - edit /opt/remi/php56/root/etc/php-fpm.d/www.conf php-fpm config"
  echo
  echo "php56 -v"
  php56 -v
  echo
  echo "which php56"
  which php56
  echo
  echo "php56 -m"
  php56 -m
  echo "php56 --ini"
  php56 --ini
  echo
}

phpupdate() {
  yum -y update $packages $repoopt
}

phplist() {
  yum list $packages $repoopt
}

case "$1" in
  install )
    phpinstall
    ;;
  update )
    phpupdate
    ;;
  list )
    phplist
    ;;
  phpconfig )
    if [ -f /opt/remi/php56/root/usr/bin/php-config ]; then
      /opt/remi/php56/root/usr/bin/php-config
    fi
    ;;
  phperrors )
    if [ -f /opt/remi/php56/root/var/log/php-fpm/www-error.log ]; then
      echo "tail -100 /opt/remi/php56/root/var/log/php-fpm/www-error.log"
      tail -100 /opt/remi/php56/root/var/log/php-fpm/www-error.log
    fi
    ;;
  phpcustom )
    if [ -f /opt/remi/php56/root/etc/php.d/zzz_customphp.ini ]; then
      nano /opt/remi/php56/root/etc/php.d/zzz_customphp.ini
    fi
    ;;
  phpslowlog )
    if [ -f /opt/remi/php56/root/var/log/php-fpm/www-slow.log ]; then
      echo "tail -100 /opt/remi/php56/root/var/log/php-fpm/www-slow.log"
      tail -100 /opt/remi/php56/root/var/log/php-fpm/www-slow.log
    fi
    ;;
  phpini )
    php56 --ini
    ;;
  phpext )
    php56 -m
    ;;
  start )
    systemctl start php56-php-fpm
    ;;
  restart )
    systemctl restart php56-php-fpm
    ;;
  stop )
    systemctl stop php56-php-fpm
    ;;
  status )
    systemctl status php56-php-fpm
    ;;
  process )
    ps aufxw | egrep -w 'php-fpm|nginx' | grep -v grep
    ;;
  * )
    echo "$0 {install|update|list|phpconfig|phperrors|phpcustom|phpslowlog|phpini|phpext|start|restart|stop|status|process}"
    ;;
esac