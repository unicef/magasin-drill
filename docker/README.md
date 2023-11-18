## Building Docker Images
The docker directory contains everything required to build and customize Docker images for the Apache Drill and Apache ZooKeeper included in the helm chart.

Docker images are available on [Docker Hub](https://hub.docker.com/u/merlos/). 


### Build ZooKeeper
The `build.sh` script in the `docker/zookeeper` folder builds the zookeeper image, tags it and uploads it to a registry. 
It takes two arguments:

```shell
./build.sh <registry> <zookeeper-version>
```
Where `registry` is the URL of the registry (for example an Azure registry whatever.acr.io). It can also be a Docker Hub username.

The project version is the version of Zookeeper that you want to setup in the image. For instance "3.9.1", The list of versions is here: https://archive.apache.org/dist/zookeeper/

Example:
```shell
cd docker/zookeeper
./build.sh merlos 3.9.1
```

In this image: 
* zookeeper is run by the user `zk`
* zookeper is installed in `/opt/zookeeper`
* Data is kept in `/var/lib/zookeeper`
* Output logs are kept in `/var/log/zookeeper/`


You have som images available in https://hub.docker.com/r/merlos/zookeeper

### Build Drill

Similarly,  the folder `docker/drill` contains the `build.sh` script that  builds, tags and uploads a docker image. It also takes two arguments:

```shell
./build.sh <registry> <drill-version>
```

The list of drill versions are in this link https://archive.apache.org/dist/drill/.

Example:
```
cd docker/drill
./build.sh merlos 1.21.1
```
