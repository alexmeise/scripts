####
# Script to restart the JBoss service
# Alexander Meise - mail@alexandermeise.com
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
JBOSS_LOG_PATH="${JBOSS_HOME}/${SERVICE}/"
LOG_NAME=/app_logs/jboss_logs/${SERVICE}/service_restart_${SERVICE}.log

#-- restart service --#

restart_service(){
echo `date` >> $LOG_NAME
echo -e "\n Service restart started" >> $LOG_NAME
echo "Proceeding with service stop"
service $SERVICE stop
echo "sleep 60 seconds..."
sleep 20
echo "renaming ${JBOSS_LOG_FILE} to ${JBOSS_LOG_FILE}.${SHORT_DATE}"
mv $JBOSS_LOG_FILE $JBOSS_LOG_FILE.$SHORT_DATE
echo "Renamed, sleep 10 seconds ..."
sleep 10
echo "Proceeding with service start"
service $SERVICE start
sleep 20
echo -e "\n Service restart finished" >> $LOG_NAME

}
#send email with result.

email_notification(){

        echo -e "Date: $(date) \nServer: $(uname -n)     \nService: $SERVICE    \nStatus: $(service $SERVICE status) \n\nDF -H:\n\n $(df -h)" | mailx -s "JBOSS RESTART" foo@bar.com,foo2@bar.com
        echo -e "\n EMAIL SENT TO ADMIN" >> $LOG_NAME
                echo -e "\n EMAIL SENT TO ADMIN"
}

delete_old_logs(){
find $JBOSS_LOG_PATH -type f -name "console.log.2*" -mtime +7  -delete
}

#MAIN PROGRAM
restart_service
delete_old_logs
email_notification
