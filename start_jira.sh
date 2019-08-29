docker run  --rm --name jira --link mysql57:mysql57 -p 8080:8080 -v /data/atlassian/jira_home:/var/atlassian/jira ottar63/rpi-oracle-jira
#docker run --detach --rm --name jira --link mysql57:mysql57 -p 8080:8080 -v /data/atlassian/jira_home:/var/atlassian/jira ottar63/rpi-docker-jira
#docker run --rm --name jira --link mysql57:mysql57 -p 8080:8080 -v /data/atlassian/jira_home:/var/atlassian/jira test-jira

