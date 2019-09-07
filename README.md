# NO-IP Dynamic DNS Update Client

A simple Docker container for running the NO-IP dynamic DNS update. It will keep current IP address in sync with your No-IP host or domain.


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
