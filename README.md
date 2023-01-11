# inception
This project involves setting up a small infrastructure of various services using Docker Compose within a virtual machine. The services must be run in dedicated containers, with the container images built from either the latest stable version of Alpine or Debian. You will also need to create Dockerfiles for each service and use them in the docker-compose.yml file, and must not use pre-built images or services such as Docker Hub.

Specific tasks include setting up a Docker container with NGINX configured to use only TLSv1.2 or TLSv1.3, a container with WordPress and php-fpm installed and configured without NGINX, a container with MariaDB installed without NGINX, and creating volumes for the WordPress database and website files. Additionally, you need to create a Docker network to establish connections between the containers and make sure the containers are able to restart in case of a crash.

You have to use your own domain name for example: if your login is wil, wil.42.fr will redirect to the IP address pointing to wil’s website.
It is mandatory to use environment variables and it is recommended to use a .env file to store them.
NGINX container should be the only entry point to your infrastructure via port 443 and must use the TLSv1.2 or TLSv1.3 protocol.

You should follow best practices for writing Dockerfiles and using PID 1, also prohibited using some command such as tail -f, bash, sleep infinity, while true, network: host, --link or links. You will not use the latest tag. You must not include any passwords in your Dockerfiles.
