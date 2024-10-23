# Extract Jenkins secret and Docker group ID
JENKINS_SECRET=$(sudo docker exec jenkins_docker-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword)
DOCKER_GROUP_ID=$(sudo getent group docker | cut -d ':' -f 3)

# Create or overwrite the .env file with proper formatting
echo "JENKINS_SECRET=$JENKINS_SECRET" > ./.env 
echo "DOCKER_GROUP_ID=$DOCKER_GROUP_ID" >> ./.env
