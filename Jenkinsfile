node {
    def app 
    stage('Clone repository'){
        checkout scm
    }
    stage('Build image') {
	def jdk = new File("jdk1.8.0_221")
	if (! jdk.exists(){
		sh "cp -r /opt/src/jdk1.8.0_221 jdk1.8.0_221"
	}
	sh "ls -al"
	sh "pwd"
	sh "du"
        app = docker.build("ottar63/rpi-mysql-jira")
    }
    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
