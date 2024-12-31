# Build the Docker image
docker build -t frontend-image -f frontend.dockerfile .

# Run the Docker container
docker run -d -p 3000:80 --name frontend-container frontend-image

# Stop the running container
docker stop frontend-container

# Remove the stopped container (optional)
docker rm frontend-container