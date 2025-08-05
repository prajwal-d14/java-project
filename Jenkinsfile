pipeline {
    agent none

    environment {
        SONAR_SERVER = 'SonarServer' 
        SONAR_URL = 'http://43.205.214.225:9000/'
        NEXUS_URL = 'http://13.203.219.176:31020/repository/artifact-repo/myapp/myapp-1.0.war'
        DOCKER_IMAGE = '13.203.219.176:31503/docker-repo/myapp:1.0'
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
                        -Dsonar.projectKey=java-project \
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
                    def NEXUS_URL = "http://13.203.219.176:31020/repository/artifact-repo/myapp/myapp-1.0.war"
                  sh """
                    docker build \
                       --build-arg NEXUS_USER=$USERNAME \
                       --build-arg NEXUS_PASS=$PASSWORD \
                       --build-arg NEXUS_URL=$NEXUS_URL \
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
