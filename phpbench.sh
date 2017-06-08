#!/bin/bash
######################################################
# bench.php and micro_bench.php script for PHP 7.1.5
# written by George Liu (eva2000) centminmod.com
######################################################
# variables
#############
DT=$(date +"%d%m%y-%H%M%S")
RUNS=5

PHPBENCHLOGDIR='/home/phpbench_logs'
PHPBENCHLOGFILE="bench_${DT}.log"
PHPMICROBENCHLOGFILE="bench_micro_${DT}.log"
PHPBENCHLOG="${PHPBENCHLOGDIR}/${PHPBENCHLOGFILE}"
PHPMICROBENCHLOG="${PHPBENCHLOGDIR}/${PHPMICROBENCHLOGFILE}"
BENCHDIR='/svr-setup/php-7.1.6/Zend'
######################################################
# functions
#############
if [ ! -d "$PHPBENCHLOGDIR" ]; then
  mkdir -p $PHPBENCHLOGDIR
fi

bench() {
  cd "$BENCHDIR"
  if [[ -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71 /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php71 && ! -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71 /usr/bin/php56'
  elif [[ ! -f /usr/bin/php71 && -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php70 /usr/bin/php56'
  elif [[ -f /usr/bin/php71 && ! -f /usr/bin/php70 && ! -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php71'
  elif [[ ! -f /usr/bin/php71 && ! -f /usr/bin/php70 && -f /usr/bin/php56 ]]; then
    PHPBIN='/usr/local/bin/php /usr/bin/php56'
  else
    PHPBIN='/usr/local/bin/php'
  fi
for p in $PHPBIN; do
 DT=$(date +"%d%m%y-%H%M%S")
 echo -e "\n$(date)" >> $PHPBENCHLOG
 PHPBENCHLOGFILE="bench_${DT}.log"
 PHPBENCHLOG="${PHPBENCHLOGDIR}/${PHPBENCHLOGFILE}"
 touch "$PHPBENCHLOG"
 for ((i = 0 ; i < $RUNS ; i++)); do
  echo "----"
  echo "$p bench.php"
  {
  /usr/bin/time --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p bench.php
  } 2>&1 | tee -a $PHPBENCHLOG
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
  
  echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
  echo -e "bench.php results from $RUNS runs\n$TOTAL"
  echo
  echo "bench.php avg: $AVG"
  echo "Avg: real: ${TIMEREAL}s user: ${TIMEUSER}s sys: ${TIMESYS}s cpu: ${TIMECPU}% maxmem: ${TIMEMEM}KB cswaits: ${TIMECS}"
  echo "created results log at $PHPBENCHLOG"
  echo

 echo -e "\n$(date)" >> $PHPMICROBENCHLOG
 PHPMICROBENCHLOGFILE="bench_micro_${DT}.log"
 PHPMICROBENCHLOG="${PHPBENCHLOGDIR}/${PHPMICROBENCHLOGFILE}"
 touch $PHPMICROBENCHLOG
 for ((i = 0 ; i < $RUNS ; i++)); do
  echo "$p micro_bench.php"
  {
  /usr/bin/time --format='real: %es user: %Us sys: %Ss cpu: %P maxmem: %M KB cswaits: %w' $p micro_bench.php
  } 2>&1 | tee -a $PHPMICROBENCHLOG
 done
  MTOTAL=$(awk '/Total/ {print $2}' $PHPMICROBENCHLOG)
  MAVG=$(awk '/Total/ {print $2}' $PHPMICROBENCHLOG | awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }')
  MTIMEREAL=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $2 } END { if (NR > 0) printf "%.2f\n", sum / NR }')
  MTIMEUSER=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $4 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMESYS=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $6 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMECPU=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $8 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMEMEM=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $10 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  MTIMECS=$(echo $TOTAL | awk '/maxmem:/ {print $0}' $PHPMICROBENCHLOG | awk '{ sum += $13 } END { if (NR > 0) printf "%.2f\n", sum / NR }' )
  echo 
  
  echo "[$($p -v 2>&1 | head -n1 | cut -d ' ' -f1,2)] $p"
  echo -e "micro_bench.php results from $RUNS runs\n$MTOTAL"
  echo
  echo "micro_bench.php avg: $MAVG"
  echo "Avg: real: ${MTIMEREAL}s user: ${MTIMEUSER}s sys: ${MTIMESYS}s cpu: ${MTIMECPU}% maxmem: ${MTIMEMEM}KB cswaits: ${MTIMECS}"
  echo "created results log at $PHPMICROBENCHLOG"
  echo
done
}

######################################################

bench