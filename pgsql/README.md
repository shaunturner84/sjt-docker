= INTRODUCTION =
This image sjt-pgsql implements a basic container that runs an instance of postgresql server. 

= INSTRUCTIONS =
This inherits from image sjt-pgsql:latest so first you'll need to build that (if you haven't already):

   docker build . -t sjt-base

Once completed you can build sjt-pgsql

   docker build . -t sjt-pgsql


