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
	mkdir logs
	cf login -a ${hostURL} --skip-ssl-validation -u ${userId} -p ${password} -o ${org} -s ${space}
	cf push --hostname ${appName} > logs/deployLogs.log 2>&1
	cf logs ${appName} --recent > logs/appRecentLogs.log 2>&1
fi
