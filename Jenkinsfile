pipeline {
    agent none

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
                    sleep 20
                    cp /home/ubuntu/workspace/java-project/target/demo-0.0.1-SNAPSHOT.war /home/ubuntu/builds/
                '''
            }
        }

        stage('Deploy') {
            agent { label 'deploy' }
            steps {
                sh '''
                    scp ubuntu@172.31.7.95:/home/ubuntu/builds/demo-0.0.1-SNAPSHOT.war /opt/tomcat/apache-tomcat-10.1.24/webapps/
                    sleep 20
                    /opt/tomcat/apache-tomcat-10.1.24/bin/shutdown.sh
                    sleep 5
                    /opt/tomcat/apache-tomcat-10.1.24/bin/startup.sh
                '''
            }
        }

        stage('Test') {
            agent { label 'deploy' }
            steps {
                sh '''
                    echo test was successful
                    ip=$(curl -s http://checkip.amazonaws.com)
                    echo "Access the Deployed application from the link http://$ip:8080/demo-0.0.1-SNAPSHOT"
                '''
            }
        }
    }

    post {
        success {
            script {
                def appUrl = "http://$ip:8080/demo-0.0.1-SNAPSHOT"

                emailext(
                    subject: "Deployment Successful",
                    body: """
                        Hello Team,

                        The deployment of the application was successful.

                        You can access the app here:
                        ${appUrl}

                        Build URL: ${env.BUILD_URL}
                    """,
                    to: 'prajwaldoddananjaiah@gmail.com'
                )
            }
        }

        failure {
            emailext(
                subject: "Deployment Failed",
                body: """
                    Hello Team,

                    The Jenkins job has failed.

                    Please check the console logs here:
                    ${env.BUILD_URL}
                """,
                to: 'prajwaldoddananjaiah@gmail.com'
            )
        }
    }
}

