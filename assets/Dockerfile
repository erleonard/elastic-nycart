# docker build -t stress-test .
# docker run --rm stress-test
# https://docs.github.com/en/actions/use-cases-and-examples/publishing-packages/publishing-docker-images

# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Update the package list and install stress
RUN apt-get update && apt-get install -y stress && cp /usr/bin/stress /tmp/moneymoneymoney

# Run the stress command
CMD ["/tmp/moneymoneymoney", "--cpu", "1"]
