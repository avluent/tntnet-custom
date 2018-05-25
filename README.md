# tntnet-custom
## Description
This repo contains all the files necessary to create a stand-alone Docker Container running tntnet based of Ubuntu.
## Prerequisites
You'll need to:
* Install Docker
* Git clone this repo to the working directory of your choosing
## Installation
`git clone https://github.com/avluent/tntnet-custom.git`

`cd tntnet-custom/.docker`

And run the commands in the commands.txt file.

The script will automatically build the Docker image named after the repo. The second command will start the container with the port configured to 8000. In the current project files, you'll find one of the example projects by Tommi Maekitalo.
## The Makefile
For this build, I chose not to use automake, but to construct a makefile for my own. The easy part is that you can just drop your project files into the `src/<filetype>` folder.
## The Dockerfile
The dockerfile was composed, to use the source code in this repository. We highly recommend you adjust the docker file to your liking.
