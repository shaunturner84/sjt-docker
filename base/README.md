= INTRODUCTION =
This image sjt-base is meant to build a basic framework for building containers that can run multiple services. 

= INSTRUCTIONS =
To Build the initial image:

   docker build . -t sjt-base
   
= CONFIG FILES =
Each configuration file uploaded to /etc/sjt.containers/conf.d/ will be executed in alphabetical order. The definition of the files is very simple:

* ServiceName - The friendly name of the service 
* ServiceCmd - The command to execute
* RunAs - Who to run as
* OutOfProcess - Whether to run this command in the main process or not 0 = No 1 = Yes



