# Extract Jenkins secret and Docker group ID
JENKINS_SECRET=$(sudo docker exec jenkins_docker-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword)

# Create or overwrite the .env file with proper formatting
echo "JENKINS_SECRET=$JENKINS_SECRET" >> ./.env 
