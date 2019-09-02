#!/bin/bash
# try to sleep 60 seconds before startup  to wait for database in docker swarm
sleep 60
/opt/atlassian/jira/bin/start-jira.sh -fg

