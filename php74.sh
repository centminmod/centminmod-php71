#/bin/bash
############################################
# centminmod.com multiple PHP-FPM version
# installer for PHP 7.4 branch installed
# side by side concurrently with default
# centmin mod installed PHP version using
# using Remi YUM repo's SCL php74 version
# written by George Liu centminmod.com
############################################
DT=$(date +"%d%m%y-%H%M%S")
CENTMINLOGDIR='/root/centminlogs'
repoopt='--disableplugin=priorities --disableexcludes=main,remi --enablerepo=remi,remi-test'
packages='php74 php74-php-fpm php74-php-devel php74-php-embedded php74-php-mysqlnd php74-php-bcmath php74-php-enchant php74-php-gd php74-php-pecl-geoip php74-php-gmp php74-php-pecl-igbinary php74-php-pecl-igbinary-devel php74-php-pecl-imagick php74-php-pecl-imagick-devel php74-php-imap php74-php-intl php74-php-pecl-json-post php74-php-ldap php74-php-pecl-mailparse php74-php-mbstring php74-php-mcrypt php74-php-pecl-memcache php74-php-pecl-memcached php74-php-pecl-mysql php74-php-pdo-dblib php74-php-pspell php74-php-pecl-redis4 php74-php-snmp php74-php-soap php74-php-tidy php74-php-xml php74-php-xmlrpc php74-php-pecl-zip php74-php-opcache php74-php-sodium oniguruma5 oniguruma5-devel'

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
    CONFIGSCANDIR='/etc/opt/remi/php74/php.d'
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
    elif [[ "$TOTALMEM" -gt '1049576' && "$TOTALMEM" -le '2097252' ]]; then
        ZOLIMIT='240'
        PHP_MEMORYLIMIT='320M'
        PHP_UPLOADLIMIT='320M'
        PHP_REALPATHLIMIT='384k'
        PHP_REALPATHTTL='28800'
    elif [[ "$TOTALMEM" -gt '2097252' && "$TOTALMEM" -le '3145728' ]]; then
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
    opcachehugepages
    if [ -f /etc/opt/remi/php74/php-fpm.d/www.conf ]; then
      sed -i 's|pm.max_children = .*|pm.max_children = 20|' /etc/opt/remi/php74/php-fpm.d/www.conf
      sed -i 's|pm.max_spare_servers = .*|pm.max_spare_servers = 15|' /etc/opt/remi/php74/php-fpm.d/www.conf
    fi
}

phpinstall() {
  yum -y install $packages $repoopt
  phpsededit
  if [ ! -f /var/opt/remi/php74/log/php-fpm/www-error.log ]; then
    touch /var/opt/remi/php74/log/php-fpm/www-error.log
    chmod 0666 /var/opt/remi/php74/log/php-fpm/www-error.log
    chown nginx:nginx /var/opt/remi/php74/log/php-fpm/www-error.log
  fi
  if [ ! -f /var/opt/remi/php74/log/php-fpm/www-slow.log ]; then
    touch /var/opt/remi/php74/log/php-fpm/www-slow.log
    chmod 0666 /var/opt/remi/php74/log/php-fpm/www-slow.log
    chown nginx:nginx /var/opt/remi/php74/log/php-fpm/www-slow.log
  fi
  echo "systemctl stop php74-php-fpm" >/usr/bin/fpm74stop ; chmod 700 /usr/bin/fpm74stop
  echo "systemctl start php74-php-fpm" >/usr/bin/fpm74start ; chmod 700 /usr/bin/fpm74start
  echo "systemctl restart php74-php-fpm" >/usr/bin/fpm74restart ; chmod 700 /usr/bin/fpm74restart
  echo "systemctl reload php74-php-fpm" >/usr/bin/fpm74reload ; chmod 700 /usr/bin/fpm74reload
  echo "systemctl status php74-php-fpm" >/usr/bin/fpm74status ; chmod 700 /usr/bin/fpm74status
  echo "nano -w /etc/opt/remi/php74/php-fpm.d/www.conf" >/usr/bin/fpmconfphp74 ; chmod 700 /usr/bin/fpmconfphp74
  echo "nano -w /usr/local/nginx/conf/php74-remi.conf" >/usr/bin/phpincphp74 ; chmod 700 /usr/bin/phpincphp74
  cp -a /usr/local/nginx/conf/php.conf /usr/local/nginx/conf/php74-remi.conf
  sed -i 's|\[www\]|\[php74-www\]|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|9000|12000|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|9000|12000|' /usr/local/nginx/conf/php74-remi.conf
  sed -i 's|;listen.backlog = .*|;listen.backlog = 511|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|;listen.owner = .*|listen.owner = nginx|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|;listen.group = .*|listen.group = nginx|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|user = apache|user = nginx|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|group = apache|group = nginx|' /etc/opt/remi/php74/php-fpm.d/www.conf
  sed -i 's|;pm.status_path = \/status|pm.status_path = \/php74status|' /etc/opt/remi/php74/php-fpm.d/www.conf

  # raise system limits
  mkdir -p /etc/systemd/system/php74-php-fpm.service.d
  echo -en "[Service]\nLimitNOFILE=262144\nLimitNPROC=16384\n" > /etc/systemd/system/php74-php-fpm.service.d/limit.conf
  systemctl daemon-reload

  echo
  echo "start php74-php-fpm service"
  systemctl start php74-php-fpm
  systemctl enable php74-php-fpm
  echo
  echo "status php74-php-fpm service"
  systemctl status php74-php-fpm
  echo
  echo "command shortcuts"
  echo "phpincphp74 - edit /usr/local/nginx/conf/php74-remi.conf include file"
  echo "fpmconfphp74 - edit /etc/opt/remi/php74/php-fpm.d/www.conf php-fpm config"
  echo
  echo "php74 -v"
  php74 -v
  echo
  echo "which php74"
  which php74
  echo
  echo "php74 -m"
  php74 -m
  echo "php74 --ini"
  php74 --ini
  echo
}

phpupdate() {
  yum versionlock delete ImageMagick6 ImageMagick6-devel ImageMagick6-c++ ImageMagick6-c++-devel ImageMagick6-libs
  yum -y update $packages $repoopt
  yum versionlock ImageMagick6 ImageMagick6-devel ImageMagick6-c++ ImageMagick6-c++-devel ImageMagick6-libs
}

phplist() {
  echo
  yum -q list $packages $repoopt | tr -s ' ' | column -t
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
    if [ -f /opt/remi/php74/root/usr/bin/php-config ]; then
      /opt/remi/php74/root/usr/bin/php-config
    fi
    ;;
  phperrors )
    if [ -f /var/opt/remi/php74/log/php-fpm/www-error.log ]; then
      echo "tail -100 /var/opt/remi/php74/log/php-fpm/www-error.log"
      tail -100 /var/opt/remi/php74/log/php-fpm/www-error.log
    fi
    ;;
  phpcustom )
    if [ -f /etc/opt/remi/php74/php.d/zzz_customphp.ini ]; then
      nano /etc/opt/remi/php74/php.d/zzz_customphp.ini
    fi
    ;;
  phpslowlog )
    if [ -f /var/opt/remi/php74/log/php-fpm/www-slow.log ]; then
      echo "tail -100 /var/opt/remi/php74/log/php-fpm/www-slow.log"
      tail -100 /var/opt/remi/php74/log/php-fpm/www-slow.log
    fi
    ;;
  phpini )
    php74 --ini
    ;;
  phpext )
    php74 -m
    ;;
  start )
    systemctl start php74-php-fpm
    ;;
  restart )
    systemctl restart php74-php-fpm
    ;;
  stop )
    systemctl stop php74-php-fpm
    ;;
  status )
    systemctl status php74-php-fpm
    ;;
  process )
    ps aufxw | egrep -w 'php-fpm|nginx' | grep -v grep
    ;;
  * )
    echo "$0 {install|update|list|phpconfig|phperrors|phpcustom|phpslowlog|phpini|phpext|start|restart|stop|status|process}"
    ;;
esac