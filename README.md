This is a [VirtualBox](https://www.virtualbox.org/) based [vagrant](https://www.vagrantup.com/) box that showcases how we use [Docker](https://www.docker.com/) at [e-table.gr](https://www.e-table.gr). 

# Setup

## Dependencies

You'll need to install the following: 

- https://www.virtualbox.org/
- https://www.vagrantup.com/

Latest stable versions will do. You do not need to install Docker, it will be installed in the box during provisioning (see [provisioning/docker.sh](./provisioning/docker.sh)).

## Local domain

You can point http://docker-madness.local/ to the vagrant box by adding this to your hosts file: 

    192.168.10.7 docker-madness.local

If everything works, you should see a `phpinfo()` page.

# Docker

In the current setup, we use two docker containers: 

- nginx:alpine - An Alpine Linux flavour of [nginx's docker image](https://hub.docker.com/_/nginx).

- etable/php7.2-dev - A custom PHP 7.2 container, based on the Alpine Linux flavour [php's docker image](https://hub.docker.com/_/php).

## etable/php7.2-dev

The repository for the custom container is: https://github.com/etablegr/dev-dockerfiles

Our customizations over the base PHP 7.2 container are:

- We install a few extensions required by our apps
- We change a few variables in php.ini to better fit our needs
- We install [Composer](https://getcomposer.org/)

For the gory details, see: https://github.com/etablegr/dev-dockerfiles/blob/master/dockerfiles/Dockerfile_develop

## Docker Compose

Since we need more than one containers, we use [Docker Compose](https://docs.docker.com/compose/) to configure and run them. This is also installed during provisioning. 

The configuration for the containers is in [code/docker-compose.yml](./code/docker-compose.yml):

- We name the containers,
- We define links between them (see `nginx.links`),
- We define a volume to give our containers access to our files

All we need to do for our containers to run is: 

    docker-compose -f <configuration> up -d

From inside our vagrant box, this translates to: 

    sudo docker-compose -f /home/vagrant/code/docker-compose.yml up -d

And to stop our containers: 

    sudo docker-compose -f /home/vagrant/code/docker-compose.yml down -v

# Useful docker commands 

## List containers 

    docker ps

Lists docker containers. In our box, expect an output like: 

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    106913be2bb6        nginx:alpine        "nginx -g 'daemon of…"   3 minutes ago       Up 3 minutes        0.0.0.0:80->80/tcp   code_nginx_1
    a1f0564ce457        etable/php7.2-dev   "/usr/local/bin/entr…"   3 minutes ago       Up 3 minutes        9000/tcp             code_php72_1

More details: https://docs.docker.com/engine/reference/commandline/ps/

## Start a shell in a running container 

    docker exec -it <container id|name> /bin/sh
    docker exec -it -u <user:group> <container id|name> /bin/sh 

For our containers, this translates to:

    docker exec -it code_nginx_1 /bin/sh
    docker exec -it -u www-data:www-data code_php72_1 /bin/sh    

You can exit the container with `exit`

More details: https://docs.docker.com/engine/reference/commandline/exec/

## Run a command in an isolated container

    docker run <container> <command>

For example: 

    docker run etable/php7.2 php -v

More details: https://docs.docker.com/engine/reference/commandline/run/
