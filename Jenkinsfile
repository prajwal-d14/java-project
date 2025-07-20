pipeline {
    agent none

    environment {
        IMAGE = "14prajwal/my-app.1"
    }

    stages {
        stage('SCM Checkout') {
            agent { label 'image' }
            steps {
                git branch: 'main', url: 'https://github.com/prajwal-d14/java-project.git'
            }
        }

        stage('Build') {
            agent { label 'image' }
            steps {
                sh "docker build -t $IMAGE ."
            }
        }

        stage('Push Image') {
            agent { label 'image' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes Environment') {
            agent { label 'image' }
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'kubemaster',
                                transfers: [
                                    sshTransfer(
                                        cleanRemote: false,
                                        excludes: '',
                                        execCommand: 'kubectl apply -f /home/ubuntu/java-project/deployment.yml',
                                        execTimeout: 120000,
                                        flatten: false,
                                        makeEmptyDirs: false,
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+',
                                        remoteDirectory: '/home/ubuntu/java-project/',
                                        remoteDirectorySDF: false,
                                        removePrefix: '',
                                        sourceFiles: 'deployment.yml'
                                    )
                                ],
                                usePromotionTimestamp: false,
                                useWorkspaceInPromotion: false,
                                verbose: false
                            )
                        ]
                    )
                }
            }
        }
    }
}
