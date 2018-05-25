# tntnet-custom
## Description
This repo contains all the files necessary to create a stand-alone Docker Container running tntnet based of Ubuntu. TNTnet is a C++ webserver, that can be configured as a regular webserver, or can be compiled into your application directly, making your standalone C++ application available for the web. *Isn't that awesome?*

The configuration for your "webserver" application can be found in main.cpp - Your application is compiled with the tntnet application and CXXtools libraries included. I've also included the TNTdb libraries in this build, to enable your C++ application for database usage.
## Prerequisites
You'll need to:
* Install Docker
* Git clone this repo to the working directory of your choosing
## Installation
`git clone https://github.com/avluent/tntnet-custom.git`

And run the commands in the commands.txt file.

`bash -i commands.txt`


The script will automatically build the Docker image named after the repo. The second command will start the container with the port configured to 8000. In the current project files, you'll find one of the example projects by Tommi Maekitalo.
## The Makefile
For this build, I chose not to use automake, but to construct a makefile for my own. The easy part is that you can just drop your project files into the `src/<filetype>` folder. The Docker file will manage the make process while building the Docker image.
## tntnet
For more information on this great project, visit the following git Repo or the website:
`https://github.com/maekitalo`

`http://www.tntnet.org/`
## Still to come
On my wish/to-do list is building a shell script/docker file that will "upload" your project to the container, run make and enable you to develop as you go. Should you be interested, leave me a message.
