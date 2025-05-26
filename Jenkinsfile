pipeline{
	agent none
		stages{
			stage( 'SCM Checkout' ){
				agent { label 'compile' }
					steps{
						git branch: 'main', url: 'https://github.com/prajwal-d14/java-project.git' 
					}
			}	
			stage( 'Build' ){
				agent{ label 'compile' }
				steps{
					sh '''
						mvn clean install
						sleep 20
						cp /home/ubuntu/workspace/Build/target/demo-0.0.1-SNAPSHOT.war /home/ubuntu/builds/
						'''
				}
			}
			stage( 'Deploy' ){
				agent { label 'deploy' }
				steps{
					sh '''
						scp ubuntu@172.31.7.95:/home/ubuntu/builds/demo-0.0.1-SNAPSHOT.war /opt/tomcat/apache-tomcat-10.1.24/webapps/
						sleep 10
						sudo /opt/tomcat/apache-tomcat-10.1.24/bin/shutdown.sh
						sleep 5
						sudo /opt/tomcat/apache-tomcat-10.1.24/bin/startup.sh
					'''
				}
			}
			stage( 'Test' ){
				agent { label 'deploy' }
				steps{
					sh ' echo test was successful '
				}
			}


		}		
}
