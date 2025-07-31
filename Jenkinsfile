pipeline {
	agent none

		environment {
			SONAR_SERVER = 'SonarServer'
				SONAR_URL = 'http://13.203.158.19:30123/'
		}

	stages {
		stage('SCM Checkout') {
			agent { label 'compile' }
			steps {
				git branch: 'main', url: 'https://github.com/prajwal-d14/java-project.git'
			}
		}

		stage('SonarQube Analysis') {
			agent { label 'compile' }
			steps {
				withSonarQubeEnv("${SONAR_SERVER}") {
					sh '''
						/opt/sonar-scanner/bin/sonar-scanner \
						-Dsonar.projectKey=javaproject \
						-Dsonar.projectName="Java Project" \
						-Dsonar.sources=src \
						-Dsonar.java.binaries=target/classes
						'''
				}
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
	}
}	
