## Building Docker Images
The docker directory contains everything required to build and customize Docker images for the Apache Drill and Apache ZooKeeper included in the helm chart.

Docker images are available on [Docker Hub](https://hub.docker.com/u/merlos/). 


### Build ZooKeeper
The `build.sh` script in the `docker/zookeeper` folder builds the zookeeper image, tags it and uploads it to a registry. 
It takes two arguments:

```shell
./build.sh -r <registry> -v <zookeeper-version> [-t <tag>] [-p] 
```
Where `registry` is the URL of the registry (for example, an Azure registry whatever.acr.io). For Docker Hub, just use your username.

The project version is the version of Zookeeper that you want to setup in the image. For instance "3.9.3", The list of versions is here: https://archive.apache.org/dist/zookeeper/

Example:
```shell
cd docker/zookeeper
./build.sh -r merlos -v 3.9.3
```

By default it does not push the image to the registry. You can add `-p` to push the image to the registry.

By default it creates the same tag as the version. You can use `-t` to create a different tag. For instance: 

```shell
./build.sh -r merlos -v 3.9.3 -t 3.9.3-deb -p
```

In this image: 
* zookeeper is run by the user `zk`
* zookeeper is installed in `/opt/zookeeper`
* Data is kept in `/var/lib/zookeeper`
* Output logs are kept in `/var/log/zookeeper/`

You have some images available in https://hub.docker.com/r/merlos/zookeeper

### Build Drill

Similarly,  the folder `docker/drill` contains the `build.sh` script that  builds, tags and uploads a docker image. It also takes two arguments:

```shell
./build.sh -r <registry> -v <drill-version> [-t <tag>] [-p]
```

The list of drill versions are in this link https://archive.apache.org/dist/drill/.

Example:

```shell
cd docker/drill
./build.sh -r merlos -v 1.21.2
```

Where merlos is a user in dockerhub and 1.21.2 is the version of Drill. 

Similarly to the zookeper script, it also accepts `-t`  and `-p`.

```shell
./build.sh -r merlos -v 1.21.2 -t 1.21.2-deb -p
```

In this image: 
* drill is run by the user `drill`
* drill is installed in `/opt/drill`
* Output logs are kept in `/var/log/drill/`
* Copies the two jars included in the `jar/` folder (azure-storage and handoop-azure)

You have some images available already on https://hub.docker.com/r/merlos/drill/tags