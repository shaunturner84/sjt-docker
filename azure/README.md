INTRODUCTION:
This image sjt-azure implements a basic container that has the tools required to talk to azure via the azure-cli tools. This will later be inherited by other containers to run various solutions for azure

INSTRUCTIONS:
This inherits from image sjt-cron:latest so first you'll need to build that and the base (if you haven't already):

   docker build . -t sjt-base

Once completed you can build sjt-azure

   docker build . -t sjt-azure

once built you can run the container into a bash window

   docker run -it sjt-azure bash

before you can pass commands to azure you will need to enable the rh python modules using the scl command:

   scl enable python27 bash

Obviously change the bash part of it to get it to do something else.

One part i'm still working on is how to get past the device login security for Microsofts API's else you'd have the manual intervention required every time you start a new container.

