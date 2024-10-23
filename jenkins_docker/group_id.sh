# Extract Jenkins secret and Docker group ID
DOCKER_GROUP_ID=$(sudo getent group docker | cut -d ':' -f 3)

# Create or overwrite the .env file with proper formatting
echo "DOCKER_GROUP_ID=$DOCKER_GROUP_ID" >> ./.env
