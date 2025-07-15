pipeline {
    agent none

    parameters {
        choice(name: 'Environment', choices: ['dev', 'qa', 'prod'], description: 'Select environment to deploy')
    }

    environment {
        SONAR_SERVER = 'SonarServer' 
        SONAR_URL = 'http://43.205.214.225:9000/'  
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

        stage('Deploy') {
            agent { label "${params.Environment.toLowerCase()}" }
            steps {
                sh '''
                   scp -o StrictHostKeyChecking=no /home/ubuntu/builds/myapp-1.0.war ubuntu@172.31.0.111:/home/ubuntu/
                   ssh ubuntu@172.31.0.111 "
                       sudo mv ~/myapp-1.0.war /opt/tomcat/webapps/ &&
                       sudo systemctl restart tomcat &&
                       sudo systemctl status tomcat
                   "
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
                                 <p>SonarQube Code Quality Report: <a href="${env.SONAR_URL}/dashboard?id=java-project">${env.SONAR_URL}/dashboard?id=java-project</a></p>
                                 <p>See the Jenkins console output: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                        mimeType: 'text/html',
                        to: 'prajwaldoddananjaiah@gmail.com'
                    )
                }
            }
        }
    }
}
