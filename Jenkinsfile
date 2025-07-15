pipeline {
    agent none
    parameters {
        choice(name: 'Environment', choices: [ 'dev', 'qa', 'prod'], description: 'Select environment to deploy')
    }
  
    stages {
        stage('SCM Checkout') {
            agent { label 'compile' }
            steps {
                git branch: 'main', url: 'https://github.com/prajwal-d14/java-project.git'
            }
        }

        stage('Build') {
            agent { label 'compile' }
            steps {
               sh '''
                    mvn clean install
                    sleep 5
                    cp /home/ubuntu/workspace/java-project/target/myapp-1.0.war /home/ubuntu/builds/
               '''

            }
        }

        stage('Deploy') {
            agent { label "${params.Environment.toLowerCase()}" }
            steps {
                sh '''
                   scp -o StrictHostKeyChecking=no ubuntu@172.31.0.111:/home/ubuntu/builds/myapp-1.0.war /home/ubuntu/
		   sudo mv ~/myapp-1.0.war /opt/tomcat/webapps/
                   sleep 5
                   sudo systemctl restart tomcat.service
                   sudo systemctl status tomcat.service
                '''
            }
        }

	stage('Test') {
	    agent { label "${params.Environment.toLowerCase()}" }
	    steps {
	        script {
			def ip = sh(script: "curl -s http://checkip.amazonaws.com", returnStdout: true).trim()
			def appUrl = "http://${ip}:8080/myapp-1.0"
			echo "Test was successful"
			echo "Access the Deployed application from the link: ${appUrl}"

			emailext (
			subject: "Build ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
			body: """<p>Job '${env.JOB_NAME} [#${env.BUILD_NUMBER}]' has finished with status: <b>${currentBuild.currentResult}</b></p>
        		<p>Application is deployed and accessible at: <a href="${appUrl}">${appUrl}</a></p>
        		<p>See the Jenkins console output: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
			mimeType: 'text/html',
			to: 'prajwaldoddananjaiah@gmail.com'
			)
		}
	     }
	}

    }
}
