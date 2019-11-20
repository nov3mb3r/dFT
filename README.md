# dFT
# docker Forensic Toolkit

Fast and lightweight image with the most popular and widely used open-source forensic tools in a lightweight and fast docker image. 

## Overview
The Docker image is based on [Alpine Linux](https://hub.docker.com/_/alpine/), the most lightweight linux container distribution.

### Install Docker
Wait! It's dangerous to go alone! 

Make sure you have the Docker engine installed. Click [here](https://docs.docker.com/install/) for detailed installation instructions.

### Build from Docker registry (Recommended)
Just :
```
sudo docker pull nov3mb3r/dFT
```
Simple isn't it?

### Run 
To deploy a container from the created image :
```
sudo docker run -it nov3mb3r/dFT /bin/ash
```
Access your case files with a shared folder between your working directory and the container.

##### Make sure you don't spoil your evidence files, by granting read-only permissions to the container. 
```
$ sudo docker run -it -v ~/cases:/cases:ro nov3mb3r/dFT /bin/ash 
```
