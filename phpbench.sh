#!/bin/bash
######################################################
# bench.php and micro_bench.php script for PHP 7.1, 
# 7.0, 5.6, 7.2, 7.3, 7.4, 8.0 etc
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
VERSION='1.2'
DT=$(date +"%d%m%y-%H%M%S")
VERBOSE='n'
OPCACHECLI='n'
# https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.jit
# tracing = 1254
# function = 1205
OPCACHE_JITCRTO='1254'
CACHETOOL='n'
RUNS=3
SLEEP=3

# Disable PHP version tests for quicker benchmarking
DISABLE_PHP_SEVEN_ZERO='y'
DISABLE_PHP_SEVEN_ONE='y'

# PHP 8 JIT
PHP_JIT='y'

PHPBENCHLOGDIR='/home/phpbench_logs'
PHPBENCHLOGFILE="bench_${DT}.log"
PHPMICROBENCHLOGFILE="bench_micro_${DT}.log"
PHPDETAILBENCHLOGFILE="detailed_benchmark_${DT}.log"
PHPBENCHLOG="${PHPBENCHLOGDIR}/${PHPBENCHLOGFILE}"
PHPMICROBENCHLOG="${PHPBENCHLOGDIR}/${PHPMICROBENCHLOGFILE}"
PHPDETAILBENCHLOG="${PHPBENCHLOGDIR}/${PHPDETAILBENCHLOGFILE}"
BENCHDIR='/home/phpbench'

DETAILBENCH='y'
TIMEBIN='/usr/bin/time'
######################################################
# functions
#############
if [ ! -d "$BENCHDIR" ]; then
  mkdir -p $BENCHDIR
fi

if [ ! -d "$PHPBENCHLOGDIR" ]; then
  mkdir -p $PHPBENCHLOGDIR
fi

if [[ "$OPCACHECLI" = [yY] ]]; then
  OPCLI='-dopcache.enable_cli=1'
  if [ -f /etc/centminmod/php.d/zendopcache.ini ]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/centminmod/php.d/zendopcache.ini
  fi
  if [ -f /etc/centminmod/php.d/zz-zendopcache.ini ]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/centminmod/php.d/zz-zendopcache.ini
  fi
  if [[ -f /usr/bin/php81 && -f /etc/opt/remi/php81/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php81/php.d/20-opcache.ini
    fpm81restart
  fi
  if [[ -f /usr/bin/php80 && -f /etc/opt/remi/php80/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php80/php.d/20-opcache.ini
    fpm80restart
  fi
  if [[ -f /usr/bin/php74 && -f /etc/opt/remi/php74/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php74/php.d/20-opcache.ini
    fpm74restart
  fi
  if [[ -f /usr/bin/php73 && -f /etc/opt/remi/php73/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php73/php.d/20-opcache.ini
    fpm73restart
  fi
  if [[ -f /usr/bin/php72 && -f /etc/opt/remi/php72/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php72/php.d/20-opcache.ini
    fpm72restart
  fi
  if [[ -f /usr/bin/php71 && -f /etc/opt/remi/php71/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php71/php.d/20-opcache.ini
    fpm71restart
  fi
  if [[ -f /usr/bin/php70 && -f /etc/opt/remi/php70/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php70/php.d/20-opcache.ini
    fpm70restart
  fi
  if [[ -f /usr/bin/php56 && -f /etc/opt/remi/php56/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=1|' /etc/opt/remi/php56/php.d/20-opcache.ini
    fpm56restart
  fi
  service php-fpm restart >/dev/null 2>&1
else
  OPCLI='-d opcache.enable_cli=0'
  if [ -f /etc/centminmod/php.d/zendopcache.ini ]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/centminmod/php.d/zendopcache.ini
  fi
  if [ -f /etc/centminmod/php.d/zz-zendopcache.ini ]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/centminmod/php.d/zz-zendopcache.ini
  fi
  if [[ -f /usr/bin/php81 && -f /etc/opt/remi/php81/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php81/php.d/20-opcache.ini
    fpm81restart
  fi
  if [[ -f /usr/bin/php80 && -f /etc/opt/remi/php80/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php80/php.d/20-opcache.ini
    fpm80restart
  fi
  if [[ -f /usr/bin/php74 && -f /etc/opt/remi/php74/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php74/php.d/20-opcache.ini
    fpm74restart
  fi
  if [[ -f /usr/bin/php73 && -f /etc/opt/remi/php73/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php73/php.d/20-opcache.ini
    fpm73restart
  fi
  if [[ -f /usr/bin/php72 && -f /etc/opt/remi/php72/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php72/php.d/20-opcache.ini
    fpm72restart
  fi
  if [[ -f /usr/bin/php71 && -f /etc/opt/remi/php71/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php71/php.d/20-opcache.ini
    fpm71restart
  fi
  if [[ -f /usr/bin/php70 && -f /etc/opt/remi/php70/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php70/php.d/20-opcache.ini
    fpm70restart
  fi
  if [[ -f /usr/bin/php56 && -f /etc/opt/remi/php56/php.d/20-opcache.ini ]]; then
    sed -i 's|opcache.enable_cli=.*|opcache.enable_cli=0|' /etc/opt/remi/php56/php.d/20-opcache.ini
    fpm56restart
  fi
  service php-fpm restart >/dev/null 2>&1
fi

cachetool_setup() {
  # install cachetool https://github.com/gordalina/cachetool
  rm -f /usr/local/bin/cachetool
  wget -qcnv -O /usr/local/bin/cachetool http://gordalina.github.io/cachetool/downloads/cachetool.phar
  chmod +x /usr/local/bin/cachetool
}

getfiles() {
  cd "$BENCHDIR"
  rm -rf bench.php
  wget -qcnv -O bench.php https://github.com/centminmod/centminmod-php71/raw/master/scripts/bench.php
  rm -rf micro_bench.php
  wget -qcnv -O micro_bench.php https://github.com/centminmod/centminmod-php71/raw/master/scripts/micro_bench.php
  rm -rf mandelbrot.php
  wget -qcnv -O mandelbrot.php https://github.com/centminmod/centminmod-php71/raw/master/scripts/mandelbrot.php
  rm -rf detailed_benchmark.php
  wget -qcnv -O detailed_benchmark.php https://github.com/centminmod/centminmod-php71/raw/master/scripts/detailed_benchmark.php
}

bench() {
  getfiles
  cachetool_setup
  cd "$BENCHDIR"
  if [[ "$DISABLE_PHP_SEVEN_ONE" = [yY] && "$DISABLE_PHP_SEVEN_ZERO" = [yY] && -f /usr/bin/php81 && -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php81 /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72'
  elif [[ "$DISABLE_PHP_SEVEN_ONE" = [yY] && "$DISABLE_PHP_SEVEN_ZERO" = [yY] && -f /usr/bin/php81 && -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php81 /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php56'
  elif [[ "$DISABLE_PHP_SEVEN_ZERO" = [yY] && -f /usr/bin/php81 && -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php81 /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71'
  elif [[ "$DISABLE_PHP_SEVEN_ZERO" = [yY] && -f /usr/bin/php81 && -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php81 /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php56'
  elif [[ -f /usr/bin/php81 && -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php81 /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php81 && -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php81 /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70'
  elif [[ -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php80 && -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php80 /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70'
  elif [[ -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70'
  elif [[ -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php74 /usr/bin/php73 /usr/bin/php72 /usr/bin/php71'
  elif [[ -f /usr/bin/php74 && -f /usr/bin/php73 && -f /usr/bin/php72 && ! -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php74 /usr/bin/php73 /usr/bin/php72'
  elif [[ -f /usr/bin/php74 && -f /usr/bin/php73 && ! -f /usr/bin/php72 && ! -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php74 /usr/bin/php73'
  elif [[ -f /usr/bin/php74 && ! -f /usr/bin/php73 && ! -f /usr/bin/php72 && ! -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php74'
  elif [[ -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php73 && -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php73 /usr/bin/php72 /usr/bin/php71 /usr/bin/php70'
  elif [[ -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php72 /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php72 /usr/bin/php71 /usr/bin/php70'
  elif [[ ! -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ ! -f /usr/bin/php72 && -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71 /usr/bin/php70'
  elif [[ ! -f /usr/bin/php72 && -f /usr/bin/php71 && ! -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71 /usr/bin/php56'
  elif [[ ! -f /usr/bin/php72 && -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71'
  elif [[ ! -f /usr/bin/php72 && ! -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php70 /usr/bin/php56'
  elif [[ ! -f /usr/bin/php72 && ! -f /usr/bin/php71 && -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php70'
  elif [[ ! -f /usr/bin/php72 && -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71'
  elif [[ ! -f /usr/bin/php72 && ! -f /usr/bin/php71 && ! -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php56'
  elif [[ -f /etc/os-release && -f /usr/bin/php ]]; then
    # ubuntu 16.0.4 check
    PHPBIN='/usr/bin/php'
    TIMEBIN='/usr/bin/time'
    if [[ -f /etc/php/7.0/cli/conf.d/20-xdebug.ini && -z $(grep -w 'xdebug.max_nesting_level=2048' /etc/php/7.0/cli/conf.d/20-xdebug.ini) ]]; then
      echo 'xdebug.max_nesting_level=2048' >> /etc/php/7.0/cli/conf.d/20-xdebug.ini
      service php7.0-fpm restart >/dev/null 2>&1
    fi
  else
    PHPBIN='/usr/local/bin/php'
  fi
for p in $PHPBIN; do
 if [[ "$p" = '/usr/local/bin/php' ]]; then
  DESC='centminmod.com php-fpm'
elif [[ -f /etc/os-release && "$p" = '/usr/bin/php' ]]; then
  DISTRO=$(awk -F '="' '/PRETTY_NAME/ {print $2}' /etc/os-release | sed -e 's|\"||')
  DESC="$DISTRO php-fpm"
 else
  DESC='remi scl php-fpm'
 fi
 # map php-fpm listening ports
 if [[ "$p" = '/usr/local/bin/php' ]]; then
  FPM_PORT='9000'
  PHPVERNUM=$(/usr/local/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php81' ]]; then
  FPM_PORT='16000'
  PHPVERNUM=$(/opt/remi/php81/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php80' ]]; then
  FPM_PORT='14000'
  PHPVERNUM=$(/opt/remi/php80/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php74' ]]; then
  FPM_PORT='12000'
  PHPVERNUM=$(/opt/remi/php74/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php73' ]]; then
  FPM_PORT='11000'
  PHPVERNUM=$(/opt/remi/php73/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php72' ]]; then
  FPM_PORT='10000'
  PHPVERNUM=$(/opt/remi/php72/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php71' ]]; then
  FPM_PORT='9900'
  PHPVERNUM=$(/opt/remi/php71/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php70' ]]; then
  FPM_PORT='9800'
  PHPVERNUM=$(/opt/remi/php70/root/usr/bin/php-config --vernum| cut -c1,3)
 elif [[ "$p" = '/usr/bin/php56' ]]; then
  FPM_PORT='9700'
  PHPVERNUM=$(/opt/remi/php56/root/usr/bin/php-config --vernum| cut -c1,3)
 fi
 # PHP 8 JIT tests
 if [[ "$PHP_JIT" = [yY] && "$PHPVERNUM" -eq '80' ]] || [[ "$PHP_JIT" = [yY] && "$PHPVERNUM" -eq '81' ]]; then
  if [[ "$OPCACHECLI" = [yY] ]]; then
    OPCLI='-dopcache.enable_cli=1'
  elif [[ "$OPCACHECLI" = [nN] ]]; then
    OPCLI='-dopcache.enable_cli=1'
  fi
  OPCLI="$OPCLI -dopcache.jit=$OPCACHE_JITCRTO -dopcache.file_update_protection=0 -dopcache.jit_buffer_size=256M"
 fi

 DT=$(date +"%d%m%y-%H%M%S")
 echo -e "\n$(date)" >> $PHPBENCHLOG
 PHPBENCHLOGFILE="bench_${DT}.log"
 PHPBENCHLOG="${PHPBENCHLOGDIR}/${PHPBENCHLOGFILE}"
 touch "$PHPBENCHLOG"
 for ((i = 0 ; i < $RUNS ; i++)); do
  if [[ "$VERBOSE" = [yY] ]]; then
    echo
  fi
  echo "----"
  echo "$p bench.php [run: $i]"
  if [[ "$VERBOSE" = [yY] ]]; then
    {
    $TIMEBIN --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p $OPCLI bench.php
    } 2>&1 | tee -a $PHPBENCHLOG
  else
    {
    $TIMEBIN --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p $OPCLI bench.php
    } 2>&1 >> $PHPBENCHLOG
  fi
 done
  TOTAL=$(awk '/Total/ {print $2}' $PHPBENCHLOG)
  AVG=$(awk '/Total/ {print $2}' $PHPBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
  TIMEREAL=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPBENCHLOG | awk '{ sum += $2 } END { if (NR > 0) printf "%.2f\n", sum / NR }')
  TIMEUSER=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPBENCHLOG | awk '{ sum += $4 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  TIMESYS=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPBENCHLOG | awk '{ sum += $6 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  TIMECPU=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPBENCHLOG | awk '{ sum += $8 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  TIMEMEM=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPBENCHLOG | awk '{ sum += $10 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  TIMECS=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPBENCHLOG | awk '{ sum += $13 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  echo 
  
  if [[ -f /etc/os-release ]]; then
    echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
  else
    echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
  fi
  echo -e "bench.php results from $RUNS runs\n$TOTAL"
  echo
  if [[ -f /etc/os-release ]]; then
    echo "$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2) $DESC : bench.php avg : $AVG"
  else
    echo "$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2) $DESC : bench.php avg : $AVG"
  fi
  echo "Avg: real: ${TIMEREAL}s user: ${TIMEUSER}s sys: ${TIMESYS}s cpu: ${TIMECPU}% maxmem: ${TIMEMEM}KB cswaits: ${TIMECS}"
  echo "created results log at $PHPBENCHLOG"
  if [[ "$CACHETOOL" = [yY] && -f /usr/local/bin/cachetool ]]; then
    cachetool opcache:configuration --fcgi=127.0.0.1:${FPM_PORT}
    cachetool opcache:status --fcgi=127.0.0.1:${FPM_PORT}
    cachetool opcache:status:scripts --fcgi=127.0.0.1:${FPM_PORT}
    cachetool stat:realpath_get --fcgi=127.0.0.1:${FPM_PORT}
    cachetool stat:realpath_size --fcgi=127.0.0.1:${FPM_PORT}
  fi
  sleep "$SLEEP"
  # if [[ "$VERBOSE" = [yY] ]]; then
    echo
  # fi

 echo -e "\n$(date)" >> $PHPMICROBENCHLOG
 PHPMICROBENCHLOGFILE="bench_micro_${DT}.log"
 PHPMICROBENCHLOG="${PHPBENCHLOGDIR}/${PHPMICROBENCHLOGFILE}"
 touch $PHPMICROBENCHLOGFILE
 for ((i = 0 ; i < $RUNS ; i++)); do
  if [[ "$VERBOSE" = [yY] ]]; then
    echo
  fi
  echo "$p micro_bench.php [run: $i]"
  if [[ "$VERBOSE" = [yY] ]]; then
    {
    $TIMEBIN --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p $OPCLI micro_bench.php
    } 2>&1 | tee -a $PHPMICROBENCHLOG
  else
    {
    $TIMEBIN --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p $OPCLI micro_bench.php
    } 2>&1 >> $PHPMICROBENCHLOG
  fi
 done
  MTOTAL=$(awk '/Total/ {print $2}' $PHPMICROBENCHLOG)
  MAVG=$(awk '/Total/ {print $2}' $PHPMICROBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
  MTIMEREAL=$(echo $MTOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $2 } END { if (NR > 0) printf "%.2f\n", sum / NR }')
  MTIMEUSER=$(echo $MTOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $4 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMESYS=$(echo $MTOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $6 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMECPU=$(echo $MTOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $8 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMEMEM=$(echo $MTOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $10 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMECS=$(echo $MTOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $13 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  echo 
  
  if [[ -f /etc/os-release ]]; then
    echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
  else
    echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
  fi
  echo -e "micro_bench.php results from $RUNS runs\n$MTOTAL"
  echo
  if [[ -f /etc/os-release ]]; then
    echo "$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2) $DESC : micro_bench.php avg : $MAVG"
  else
    echo "$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2) $DESC : micro_bench.php avg : $MAVG"
  fi
  echo "Avg: real: ${MTIMEREAL}s user: ${MTIMEUSER}s sys: ${MTIMESYS}s cpu: ${MTIMECPU}% maxmem: ${MTIMEMEM}KB cswaits: ${MTIMECS}"
  echo "created results log at $PHPMICROBENCHLOG"
  if [[ "$CACHETOOL" = [yY] && -f /usr/local/bin/cachetool ]]; then
    cachetool opcache:configuration --fcgi=127.0.0.1:${FPM_PORT}
    cachetool opcache:status --fcgi=127.0.0.1:${FPM_PORT}
    cachetool opcache:status:scripts --fcgi=127.0.0.1:${FPM_PORT}
    cachetool stat:realpath_get --fcgi=127.0.0.1:${FPM_PORT}
    cachetool stat:realpath_size --fcgi=127.0.0.1:${FPM_PORT}
  fi
  sleep "$SLEEP"
  # if [[ "$VERBOSE" = [yY] ]]; then
    echo
  # fi

 if [[ "$DETAILBENCH" = [yY] ]]; then
  echo -e "\n$(date)" >> $PHPDETAILBENCHLOG
  PHPDETAILBENCHLOGFILE="detailed_benchmark_${DT}.log"
  PHPDETAILBENCHLOG="${PHPBENCHLOGDIR}/${PHPDETAILBENCHLOGFILE}"
  touch $PHPDETAILBENCHLOG
  for ((i = 0 ; i < $RUNS ; i++)); do
    if [[ "$VERBOSE" = [yY] ]]; then
      echo
    fi
    echo "$p detailed_benchmark.php [run: $i]"
    if [[ "$VERBOSE" = [yY] ]]; then
      {
      $TIMEBIN --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p $OPCLI detailed_benchmark.php 2>&1 | egrep -v 'Undefined' |sed -e 's|<pre>||' -e 's|</pre>||'| egrep ' sec|real:'
      } 2>&1 | tee -a $PHPDETAILBENCHLOG
    else
      {
      $TIMEBIN --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p $OPCLI detailed_benchmark.php 2>&1 | egrep -v 'Undefined' |sed -e 's|<pre>||' -e 's|</pre>||'| egrep ' sec|real:'
      } 2>&1 >> $PHPDETAILBENCHLOG
    fi
  done
    DBTOTAL=$(awk '/Total/ {print $3}' $PHPDETAILBENCHLOG)
    DBAVG=$(awk '/Total/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')

    DB_FOR=$(awk '/^for/ {print $3}' $PHPDETAILBENCHLOG)
    DB_WHILE=$(awk '/^while/ {print $3}' $PHPDETAILBENCHLOG)
    DB_IF=$(awk '/^if/ {print $3}' $PHPDETAILBENCHLOG)
    DB_SWITCH=$(awk '/^switch/ {print $3}' $PHPDETAILBENCHLOG)
    DB_TERNARY=$(awk '/^Ternary/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRREPLACE=$(awk '/^str_replace/ {print $3}' $PHPDETAILBENCHLOG)
    DB_PREGREPLACE=$(awk '/^preg_replace/ {print $3}' $PHPDETAILBENCHLOG)
    DB_PREGMATCH=$(awk '/^preg_match/ {print $3}' $PHPDETAILBENCHLOG)
    DB_COUNT=$(awk '/^count/ {print $3}' $PHPDETAILBENCHLOG)
    DB_ISSET=$(awk '/^isset/ {print $3}' $PHPDETAILBENCHLOG)
    DB_TIME=$(awk '/^time/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRLEN=$(awk '/^strlen/ {print $3}' $PHPDETAILBENCHLOG)
    DB_SPRINTF=$(awk '/^sprintf/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRCMP=$(awk '/^strcmp/ {print $3}' $PHPDETAILBENCHLOG)
    DB_TRIM=$(awk '/^trim/ {print $3}' $PHPDETAILBENCHLOG)
    DB_EXPLODE=$(awk '/^explode/ {print $3}' $PHPDETAILBENCHLOG)
    DB_IMPLODE=$(awk '/^implode/ {print $3}' $PHPDETAILBENCHLOG)
    DB_NUMBERFORMAT=$(awk '/^number_format/ {print $3}' $PHPDETAILBENCHLOG)
    DB_FLOOR=$(awk '/^floor/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRPOS=$(awk '/^strpos/ {print $3}' $PHPDETAILBENCHLOG)
    DB_SUBSTR=$(awk '/^substr/ {print $3}' $PHPDETAILBENCHLOG)
    DB_INTVAL=$(awk '/^intval/ {print $3}' $PHPDETAILBENCHLOG)
    DB_INT=$(awk '/^(int)/ {print $3}' $PHPDETAILBENCHLOG)
    DB_ISARRAY=$(awk '/^is_array/ {print $3}' $PHPDETAILBENCHLOG)
    DB_ISNUMERIC=$(awk '/^is_numeric/ {print $3}' $PHPDETAILBENCHLOG)
    DB_ISINT=$(awk '/^is_int/ {print $3}' $PHPDETAILBENCHLOG)
    DB_ISSTRING=$(awk '/^is_string/ {print $3}' $PHPDETAILBENCHLOG)
    DB_IPLONG=$(awk '/^ip2long/ {print $3}' $PHPDETAILBENCHLOG)
    DB_LONGIP=$(awk '/^long2ip/ {print $3}' $PHPDETAILBENCHLOG)
    DB_DATE=$(awk '/^date/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRFTIME=$(awk '/^strftime/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRTOTIME=$(awk '/^strtotime/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRTOLOWER=$(awk '/^strtolower/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRTOUPPER=$(awk '/^strtoupper/ {print $3}' $PHPDETAILBENCHLOG)
    DB_MD=$(awk '/^md5/ {print $3}' $PHPDETAILBENCHLOG)
    DB_UNSET=$(awk '/^unset/ {print $3}' $PHPDETAILBENCHLOG)
    DB_LIST=$(awk '/^list/ {print $3}' $PHPDETAILBENCHLOG)
    DB_URLENCODE=$(awk '/^urlencode/ {print $3}' $PHPDETAILBENCHLOG)
    DB_URLDECODE=$(awk '/^urldecode/ {print $3}' $PHPDETAILBENCHLOG)
    DB_ADDSLASHES=$(awk '/^addslashes/ {print $3}' $PHPDETAILBENCHLOG)
    DB_STRIPSLASHES=$(awk '/^stripslashes/ {print $3}' $PHPDETAILBENCHLOG)
    
    DB_FORAVG=$(awk '/^for/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_WHILEAVG=$(awk '/^while/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_IFAVG=$(awk '/^if/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_SWITCHAVG=$(awk '/^switch/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_TERNARYAVG=$(awk '/^Ternary/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRREPLACEAVG=$(awk '/^str_replace/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_PREGREPLACEAVG=$(awk '/^preg_replace/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_PREGMATCHAVG=$(awk '/^preg_match/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_COUNTAVG=$(awk '/^count/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_ISSETAVG=$(awk '/^isset/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_TIMEAVG=$(awk '/^time/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRLENAVG=$(awk '/^strlen/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_SPRINTFAVG=$(awk '/^sprintf/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRCMPAVG=$(awk '/^strcmp/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_TRIMAVG=$(awk '/^trim/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_EXPLODEAVG=$(awk '/^explode/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_IMPLODEAVG=$(awk '/^implode/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_NUMBERFORMATAVG=$(awk '/^number_format/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_FLOORAVG=$(awk '/^floor/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRPOSAVG=$(awk '/^strpos/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_SUBSTRAVG=$(awk '/^substr/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_INTVALAVG=$(awk '/^intval/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_INTAVG=$(awk '/^(int)/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_ISARRAYAVG=$(awk '/^is_array/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_ISNUMERICAVG=$(awk '/^is_numeric/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_ISINTAVG=$(awk '/^is_int/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_ISSTRINGAVG=$(awk '/^is_string/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_IPLONGAVG=$(awk '/^ip2long/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_LONGIPAVG=$(awk '/^long2ip/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_DATEAVG=$(awk '/^date/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRFTIMEAVG=$(awk '/^strftime/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRTOTIMEAVG=$(awk '/^strtotime/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRTOLOWERAVG=$(awk '/^strtolower/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRTOUPPERAVG=$(awk '/^strtoupper/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_MDAVG=$(awk '/^md5/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_UNSETAVG=$(awk '/^unset/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_LISTAVG=$(awk '/^list/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_URLENCODEAVG=$(awk '/^urlencode/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_URLDECODEAVG=$(awk '/^urldecode/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_ADDSLASHESAVG=$(awk '/^addslashes/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
    DB_STRIPSLASHESAVG=$(awk '/^stripslashes/ {print $3}' $PHPDETAILBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')

    DBTIMEREAL=$(echo $DBTOTAL | awk '/maxmem:/ {print $0}' $PHPDETAILBENCHLOG | awk '{ sum += $2 } END { if (NR > 0) printf "%.2f\n", sum / NR }')
    DBTIMEUSER=$(echo $DBTOTAL | awk '/maxmem:/ {print $0}' $PHPDETAILBENCHLOG | awk '{ sum += $4 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
    DBTIMESYS=$(echo $DBTOTAL | awk '/maxmem:/ {print $0}' $PHPDETAILBENCHLOG | awk '{ sum += $6 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
    DBTIMECPU=$(echo $DBTOTAL | awk '/maxmem:/ {print $0}' $PHPDETAILBENCHLOG | awk '{ sum += $8 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
    DBTIMEMEM=$(echo $DBTOTAL | awk '/maxmem:/ {print $0}' $PHPDETAILBENCHLOG | awk '{ sum += $10 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
    DBTIMECS=$(echo $DBTOTAL | awk '/maxmem:/ {print $0}' $PHPDETAILBENCHLOG | awk '{ sum += $13 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
    if [[ "$VERBOSE" = [yY] ]]; then
      echo 
    fi
    
    if [[ -f /etc/os-release ]]; then
      echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
    else
      echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
    fi
    echo -e "detailed_benchmark.php results from $RUNS runs"
    echo
    echo "averages:"
    echo -e "for:\t\t\t\t$DB_FORAVG"
    echo -e "while\t\t\t\t$DB_WHILEAVG"
    echo -e "if\t\t\t\t$DB_IFAVG"
    echo -e "switch\t\t\t\t$DB_SWITCHAVG"
    echo -e "ternary\t\t\t\t$DB_TERNARYAVG"
    echo -e "str_replace\t\t\t$DB_STRREPLACEAVG"
    echo -e "preg_replace\t\t\t$DB_PREGREPLACEAVG"
    echo -e "preg_match\t\t\t$DB_PREGMATCHAVG"
    echo -e "count\t\t\t\t$DB_COUNTAVG"
    echo -e "isset\t\t\t\t$DB_ISSETAVG"
    echo -e "time\t\t\t\t$DB_TIMEAVG"
    echo -e "strlen\t\t\t\t$DB_STRLENAVG"
    echo -e "sprintf\t\t\t\t$DB_SPRINTFAVG"
    echo -e "strcmp\t\t\t\t$DB_STRCMPAVG"
    echo -e "trim\t\t\t\t$DB_TRIMAVG"
    echo -e "explode\t\t\t\t$DB_EXPLODEAVG"
    echo -e "implode\t\t\t\t$DB_IMPLODEAVG"
    echo -e "number_format\t\t\t$DB_NUMBERFORMATAVG"
    echo -e "floor\t\t\t\t$DB_FLOORAVG"
    echo -e "strpos\t\t\t\t$DB_STRPOSAVG"
    echo -e "substr\t\t\t\t$DB_SUBSTRAVG"
    echo -e "intval\t\t\t\t$DB_INTVALAVG"
    echo -e "int\t\t\t\t$DB_INTAVG"
    echo -e "is_array\t\t\t$DB_ISARRAYAVG"
    echo -e "is_numeric\t\t\t$DB_ISNUMERICAVG"
    echo -e "is_int\t\t\t\t$DB_ISINTAVG"
    echo -e "is_string\t\t\t$DB_ISSTRINGAVG"
    echo -e "ip2long\t\t\t\t$DB_IPLONGAVG"
    echo -e "long2ip\t\t\t\t$DB_LONGIPAVG"
    echo -e "date\t\t\t\t$DB_DATEAVG"
    echo -e "strftime\t\t\t$DB_STRFTIMEAVG"
    echo -e "strtotime\t\t\t$DB_STRTOTIMEAVG"
    echo -e "strtolower\t\t\t$DB_STRTOLOWERAVG"
    echo -e "strtoupper\t\t\t$DB_STRTOUPPERAVG"
    echo -e "md5\t\t\t\t$DB_MDAVG"
    echo -e "unset\t\t\t\t$DB_UNSETAVG"
    echo -e "list\t\t\t\t$DB_LISTAVG"
    echo -e "urlencode\t\t\t$DB_URLENCODEAVG"
    echo -e "urldecode\t\t\t$DB_URLDECODEAVG"
    echo -e "addslashes\t\t\t$DB_ADDSLASHESAVG"
    echo -e "stripslashes\t\t\t$DB_STRIPSLASHESAVG"
    echo
    if [[ -f /etc/os-release ]]; then
      echo "$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2) $DESC : detailed_benchmark.php total avg : $DBAVG"
    else
      echo "$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2) $DESC : detailed_benchmark.php total avg : $DBAVG"
    fi
    echo "Avg: real: ${DBTIMEREAL}s user: ${DBTIMEUSER}s sys: ${DBTIMESYS}s cpu: ${DBTIMECPU}% maxmem: ${DBTIMEMEM}KB cswaits: ${DBTIMECS}"
    echo "created results log at $PHPDETAILBENCHLOG"
    if [[ "$CACHETOOL" = [yY] && -f /usr/local/bin/cachetool ]]; then
      cachetool opcache:configuration --fcgi=127.0.0.1:${FPM_PORT}
      cachetool opcache:status --fcgi=127.0.0.1:${FPM_PORT}
      cachetool opcache:status:scripts --fcgi=127.0.0.1:${FPM_PORT}
      cachetool stat:realpath_get --fcgi=127.0.0.1:${FPM_PORT}
      cachetool stat:realpath_size --fcgi=127.0.0.1:${FPM_PORT}
    fi
    sleep "$SLEEP"
    # if [[ "$VERBOSE" = [yY] ]]; then
    #   echo
    # fi
  fi
done
}

######################################################
{
bench
} 2>&1 | tee -a "${PHPBENCHLOGDIR}/phpbench-summary-${DT}.log"

echo
egrep '\[PHP|bench.php avg :|micro_bench.php avg :|detailed_benchmark.php total avg :' "${PHPBENCHLOGDIR}/phpbench-summary-${DT}.log"
echo

echo "PHP Version|bench.php|micro_bench.php|detailed_benchmark.php"
egrep 'bench.php avg :|micro_bench.php avg :|detailed_benchmark.php total avg :' "${PHPBENCHLOGDIR}/phpbench-summary-${DT}.log"| sed -e 's|:|\||g'
echo

V=$(egrep '\[PHP|bench.php avg :|micro_bench.php avg :|detailed_benchmark.php total avg :' "${PHPBENCHLOGDIR}/phpbench-summary-${DT}.log" | awk -F " : " '/avg : / {print $3}')
echo "|bench.php|micro_bench.php|detailed_benchmark.php|total"
echo $V | xargs -n3 | while read x y z; do echo "|$x|$y|$z" | awk -F '|' '{print $0"|"$2+$3+$4}'; done
echo