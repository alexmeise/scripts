#!/bin/bash

####
# Script to restart the JBoss service
# Alexander Meise
# Ver 1
####

#-- Variables --#

SERVICE=$1
echo "using the following service: "
echo $SERVICE
echo " "
SHORT_DATE=$(date +"%Y%m%d%H%M")
JBOSS_HOME="/app_logs/jboss_logs/"
JBOSS_LOG_FILE="${JBOSS_HOME}/${SERVICE}/console.log"
LOG_NAME=/app_logs/jboss_logs/${SERVICE}/service_restart_${SERVICE}.log

#-- restart service --#

restart_service(){

service $SERVICE stop

sleep 10

mv $JBOSS_LOG_FILE $JBOSS_LOG_FILE.$SHORT_DATE

service $SERVICE start

}
#send email with result.

email_notification(){

        echo `service $SERVICE status`
        echo $STATUS
        echo -e "\nDate: $DATE    Server: $(uname -n)     \n\nService: $SERVICE     Status: $STATUS" | mailx -s $1 -r JBoss_scheduled_instance_restart mail@service.com,mail@service.com
        echo -e "\n EMAIL SENT TO ADMIN" >> $LOG_NAME
                echo -e "\n EMAIL SENT TO ADMIN"
}

#MAIN PROGRAM
#restart_service
email_notification
