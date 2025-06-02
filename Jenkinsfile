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
                    sleep 5
                    cp /home/ubuntu/workspace/java-project/target/demo-0.0.1-SNAPSHOT.war /home/ubuntu/builds/
                '''
            }
        }

        stage('Deploy') {
            agent { label 'deploy' }
            steps {
                sh '''
                   scp ubuntu@172.31.7.95:/home/ubuntu/builds/demo-0.0.1-SNAPSHOT.war /opt/tomcat/webapps/
                   sleep 5
                   sudo systemctl restart tomcat.service
                   sudo systemctl status tomcat.service
                   
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
}

