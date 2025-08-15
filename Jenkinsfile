ipipeline {
    agent none

    environment {
        SONAR_SERVER = 'SonarServer' 
        NEXUS_URL = 'http://65.1.108.247:31020/repository/java-artifact/myapp/myapp-1.0.war'
        DOCKER_IMAGE = '65.1.108.247:31503/docker-repo/myapp:1.0'
    }

    stages{
		stage(checkout){
            agent { label 'compile' }
            steps {
                git branch: 'prajwal-developer', url: 'https://github.com/prajwal-d14/java-project.git'
            }
        }

        stage('SonarQube Analysis') {
            agent { label 'compile' }
            steps {
                withSonarQubeEnv("${SONAR_SERVER}") {
                    sh '''
                        /opt/sonar-scanner/bin/sonar-scanner \
                        -Dsonar.projectKey=java-project \
                        -Dsonar.projectName="Java Project" \
                        -Dsonar.sources=src \
                        -Dsonar.java.binaries=target/classes \
						-Dsonar.projectVersion=${BUILD_NUMBER} \
						-Dsonar.branch.name=${BRANCH_NAME}
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
                    cp target/myapp-1.0.war ~/builds/
                '''
            }
        }

        stage('Upload Artifact to Nexus') {
            agent { label 'compile' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        curl -u $USERNAME:$PASSWORD \
                          --upload-file ~/builds/myapp-1.0.war \
                          $NEXUS_URL
                    """
                }
            }
        }

        stage('Docker Image Creation') {
            agent { label 'image' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                         docker build \
                        --build-arg NEXUS_USER=$USERNAME \
                        --build-arg NEXUS_PASS=$PASSWORD \
						--build-arg ARTIFACT_URL=$NEXUS_URL \
                        -t myapp:1.0 .
                    """
				}	
            } 
        }

        stage('Docker Image Push to Nexus') {
            agent { label 'image' }
            steps {
                sh """
                    docker tag myapp:1.0 $DOCKER_IMAGE
                    docker push $DOCKER_IMAGE
                """
            }
        }
    }
}
