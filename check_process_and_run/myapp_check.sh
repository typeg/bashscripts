#!/bin/bash -l

VAULT_HOME=/app/myapp/media/real
HOSTNAME=$(hostname -s)
DBCHECK_FILENAME=$VAULT_HOME/share/db_status.txt

if [ "$1" == "glassfish" ]; then
  PROCESS_CHECK_STRING='glassfish.jar'
elif [ "$1" == "mysql" ]; then
  PROCESS_CHECK_STRING='mysqld'
elif [ "$1" == "nginx" ]; then
  PROCESS_CHECK_STRING='nginx:'
elif [ "$1" == "apache" ]; then
  PROCESS_CHECK_STRING='httpd'
else
  echo "Usage: myapp_check.sh glassfish|mysql|nginx|apache [-start|-stop|-cron]"
  exit 1
fi

PROCESS_NAME=$1

LOG_MONTH=`date +%Y-%m`
LOG_TIME=`date '+%Y-%m-%d %H:%M:%S'`
if [ "$2" == "-cron" ]
  then
    LOG_FILE=$HOME/shell/logs/myapp_proc_${LOG_MONTH}.log
  else
    LOG_FILE=/dev/stdout
fi


function start_proc () {
  echo "Starting" $PROCESS_NAME >> $LOG_FILE
  if [ "$PROCESS_NAME" == "glassfish" ]; then
    if [ $(cat $DBCHECK_FILENAME) == "ONLINE" ]; then
        asadmin start-domain domain1 >> $LOG_FILE 2>&1
    fi
  elif [ "$PROCESS_NAME" == "mysql" ]; then
    $HOME/db/mysql/startup.sh >> $LOG_FILE 2>&1
  elif [ "$PROCESS_NAME" == "nginx" ]; then
    $HOME/nginx/bin/nginx.sh start >> $LOG_FILE 2>&1
  elif [ "$PROCESS_NAME" == "apache" ]; then
    $HOME/apache/bin/apachectl start >> $LOG_FILE 2>&1
  fi
}

function stop_proc () {
  echo "Stopping" $PROCESS_NAME >> $LOG_FILE
  if [ "$PROCESS_NAME" == "glassfish" ]; then
    asadmin stop-domain domain1 >> $LOG_FILE 2>&1
  elif [ "$PROCESS_NAME" == "mysql" ]; then
    $HOME/db/mysql/shutdown.sh >> $LOG_FILE 2>&1
  elif [ "$PROCESS_NAME" == "nginx" ]; then
    $HOME/nginx/bin/nginx.sh stop >> $LOG_FILE 2>&1
  elif [ "$PROCESS_NAME" == "apache" ]; then
    $HOME/apache/bin/apachectl stop >> $LOG_FILE 2>&1
  fi
}

if pgrep -f -u $USER $PROCESS_CHECK_STRING >/dev/null 2>&1
  then
    echo $LOG_TIME ":" $PROCESS_NAME "is OK" >> $LOG_FILE
    if [ "$2" == "-stop" ]; then
      stop_proc
    fi
  else
    echo $LOG_TIME ":" $PROCESS_NAME "is not running" >> $LOG_FILE
    if [ "$2" == "-cron" ] || [ "$2" == "-start" ]; then
      start_proc
    fi
fi