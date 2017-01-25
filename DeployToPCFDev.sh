#!/bin/bash
###############################################################################
# Name			: 	DeployToPCFDev.sh
# Author		: 	Swarada Kalekar
# Created on	: 	Jan 2017
# Description 	: 	Script is written to deploy the application 
# 					on PCF Dev Environment. Script will accept 
#					User Details, Organization, Space, Application details
###############################################################################

if [ ${#} -ne 6 ]; then
	echo "Usage: DeployToPCFDev.sh <HostURL> <UserId> <Password> <Org> <Space> <ApplicationName>"
else
	export hostURL=$1
	export userId=$2
	export password=$3
	export org=$4
	export space=$5
	export appName=$6
	rm -rf logs
	mkdir logs
	cf login -a ${hostURL} --skip-ssl-validation -u ${userId} -p ${password} -o ${org} -s ${space}
	cnt=1
	while [ $cnt -lt 4 ] 
	do
		echo "" >> logs/deployLogs.log
		echo "***************Deploy attempt $cnt******************" >> logs/deployLogs.log
		echo "" >> logs/deployLogs.log
		cf push --hostname ${appName} >> logs/deployLogs.log 2>&1
		
		if [ 1 -ge `cat logs/deployLogs.log | grep 'App started' | wc -l` ]; then
			cf logs ${appName} --recent > logs/appRecentLogs.log 2>&1
			echo "App deployed and started successfully"
			echo "Check logs/deployLogs.log and logs/appRecentLogs.log files for more details"
			echo "Exit 1 with Success"
			exit 1
		fi
		cnt=`expr $cnt + 1`
	done
	echo "Exit 2 with error"
	exit 2
fi
