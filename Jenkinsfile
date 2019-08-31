node {
    def app 
    stage('Clone repository'){
        checkout scm
    }
    stage('Build image') {
	sh "cp -r /opt/src/jdk1.8.0_221 jdk1.8.0_221"
	sh "ls -al"
	sh "pwd"
	sh "du"
	sh "ls jdk1.8.0.221"
        app = docker.build("ottar63/rpi-mysql-jira")
    }
    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
