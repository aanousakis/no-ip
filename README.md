![Docker Pulls](https://img.shields.io/docker/pulls/aanousakis/no-ip?style=plastic)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/aanousakis/no-ip/latest)

# NO-IP Dynamic DNS Update Client

A simple [Docker container](https://hub.docker.com/r/aanousakis/no-ip) for running the NO-IP dynamic DNS update. It will keep current IP address in sync with your No-IP host or domain.

⚠️ Raspberry Pi users running 32 bit systems: The latest alpine update causes high cpu utilization. You can either use tag 1.0, which uses alpine:1.12 or [update libseccomp](https://github.com/alpinelinux/docker-alpine/issues/135#issuecomment-812287338)

## Usage

### Running  the container
   
There are two ways of running this container. As a regular container and as a service.

#### Regular container:
Running the image as a regular container uses environment variables to pass username, password, domains and interval from the host to the container. 



```bash
docker container run -d -e USERNAME=user1 -e PASSWORD=123 -e "DOMAINS=domain1.ddns.net" -e INTERVAL=5 aanousakis/no-ip

```
You can add multiple domains ex "DOMAINS=domain1.ddns.net domain2.ddns.net domain.foo.com"

#### As a service:
Running the image as a service uses secrets to pass username, password, domains and interval from the host to the container.

First you have to install docker compose

[installation instructions](https://docs.docker.com/compose/install/)

Then download docker-compose.yml file and the scripts to set Docker secrets. 

```bash
git clone https://github.com/aanousakis/no-ip.git    
cd no-ip/
```

Then you can deploy the service with :


```bash
docker swarm init
./deploy.sh 
```
The deploy.sh script will ask for your username, password, domains and update interval. Then it will set the secrets and start a service called no-ip_service. 

The service if configured to restart if an error occurs.


### Building the image
The image in Docker hub is build for the x86_64 architecture and cannot run on other platforms. If, for example, you want to run it on a host with arm architecture, you must build the image in that host.

```bash
git clone https://github.com/aanousakis/no-ip.git    
cd no-ip/
docker build --tag=aanousakis/no-ip .

```
## Author

* **Antony Anousakis**
