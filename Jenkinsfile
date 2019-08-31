node {
    def app 
    stage('Clone repository'){
        checkout scm
    }
    stage('Build image') {
	sh "ln -sf /opt/src/jdk1.8.0_221 jdk1.8.0_221"
	sh "ls -al"
        app = docker.build("ottar63/rpi-mysql-jira")
    }
    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}