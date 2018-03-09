INTRODUCTION:
This image sjt-pgsql implements a basic container that runs an instance of postgresql server. 

INSTRUCTIONS:
This inherits from image sjt-base:latest so first you'll need to build that (if you haven't already):

   docker build . -t sjt-base

Once completed you can build sjt-pgsql

   docker build . -t sjt-pgsql

once the container is built you can run a copy of it using the following command:

   docker run -it sjt-pgsql:latest

In the logs you will be able to see the initial password for the sjtadmin account:

   docker logs <container name>
   
example: initial sjtadmin password: SQQvNSSYe9  - please change ASAP

You will also need to download the client certificate and key before you can connect to it using psql (or anything else)

   docker cp <container name>:/tmp/client.crt /tmp/
   docker cp <container name>:/tmp/client.key /tmp/

you can get the ip address of the container from:

   docker inspect -f "{{ .NetworkSettings.IPAddress }}" <container name>

to connect using psql:

   psql "sslmode=require host=172.17.0.2 user=sjtadmin dbname=postgres sslcert=/tmp/client.crt sslkey=/tmp/client.key"

Once logged in don't forget to change the sjtadmin password.