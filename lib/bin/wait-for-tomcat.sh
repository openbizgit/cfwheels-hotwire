#!/bin/bash

# ping the app every x seconds until i get a response
echo "Checking if Tomcat is ready..."
date
until [ "`curl --silent --show-error --connect-timeout 1 'http://127.0.0.1/ahoy/checks/ping' | grep '{ping:true}'`" != "" ];
do
	echo "Nope... sleeping for 5 seconds"
	date
	sleep 5
done
echo "Tomcat is ready..."
date