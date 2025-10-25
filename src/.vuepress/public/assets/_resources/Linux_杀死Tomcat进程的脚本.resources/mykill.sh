#!/bin/sh

Cur_Dir=$(pwd)
echo "tomcat path："$Cur_Dir

processId=$(ps -ef | grep tomcat | grep -w $Cur_Dir | grep -v 'grep' | awk '{print $2}')

if [ $processId ]; then
   echo "tomcat processId："$processId
   kill -9 $processId
   echo "kill success！"
else
   echo "tomcat processId is not exist"
   echo "kill failed！"
fi
