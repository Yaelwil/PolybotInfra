# Initialize the Jenkins secret variable
JENKINS_SECRET=""

# Wait for the Jenkins initialAdminPassword file to be available
while [ -z "$JENKINS_SECRET" ]; do
    JENKINS_SECRET=$(sudo docker exec jenkins_docker-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword)
    sleep 5  # Wait for 5 seconds before trying again
done
# Create or overwrite the .env file with proper formatting
echo "JENKINS_SECRET=$JENKINS_SECRET" >> ./.env
