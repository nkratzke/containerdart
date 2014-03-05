Container Dart
==============

[Docker][docker] is an open-source engine that automates the deployment of applications as portable and self-sufficient containers that will run virtually anywhere. Dockerized applications reduce configuration efforts and obstacles for administrators. Applications can be provided in a configured, self-sufficient and frictionless way.

Container Dart shows how this can be accomplished for [Dart][dart] server applications.

Container Dart is just a simple HTML page which is provided by a very simple static [Dart][dart] HTTP server using the [Sinatra][sinatra] inspired web framework [Start][start].

```Dart
import 'package:start/start.dart';

main() {
  start(host: '0.0.0.0', port: 8080).then((Server app) {
    app.static('../build/web');
  });
}
```

This server runs in a docker container and can be started on every system which has docker installed like this:

```Shell
docker build -t containerdart github.com/nkratzke/containerdart
docker run -p 8888:8080 -d containerdart
```

First command build a new image from a Dockerfile provided in the referenced github repository (this here). The repository is a normal dart repository being processable by pub but has addtionally a so called Dockerfile in it. This Dockerfile defines the image for a container. Therefore 

- it extends a barebone Ubuntu 13.10 system,
- installs additionally Dart SDK,
- copies the application files into the container (bin and web directory),
- starts the build process on the system,
- defines an entrypoint (which is beeing called when the container is started by docker)
- and finally tag it _containerdart_.

Second command starts the container as a daemon and binds the internal port 8080 to the host port 8888 (it is also possible to map the exposed container port 8080 to any other port number, e.g. 80).

Now your container is accessible via [http://localhost:8888](http://localhost:8888).

__Thats all.__ All the magic is done by docker processing the following Dockerfile which can be easily adapted to your Dart application.

```Shell
# Install a dart container for demonstration purposes.
# Your dart server app will be accessible via HTTP on container port 8080. The port can be changed.
# You should adapt this Dockerfile to your needs.
# If you are new to Dockerfiles please read 
# http://docs.docker.io/en/latest/reference/builder/
# to learn more about Dockerfiles.
#
# This file is hosted on github. Therefore you can start it in docker like this:
# > docker build -t containerdart github.com/nkratzke/containerdart
# > docker run -p 8888:8080 -d containerdart

FROM stackbrew/ubuntu:13.10
MAINTAINER Nane Kratzke <nane@nkode.io>

# Install Dart SDK. Do not touch this until you know what you are doing.
# We do not install darteditor nor dartium because this is a server container.
# See: http://askubuntu.com/questions/377233/how-to-install-google-dart-in-ubuntu
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-add-repository ppa:hachre/dart
RUN apt-get -y update
RUN apt-get install -y dartsdk

# Install the dart server app. 
# Comment in necessary parts of your dart package necessary to run "pub build"
# and necessary for your working app.
# Please check the following links to learn more about pub and build dart apps
# automatically.
# - https://www.dartlang.org/tools/pub/
# - https://www.dartlang.org/tools/pub/package-layout.html
# - https://www.dartlang.org/tools/pub/transformers
ADD pubspec.yaml  /container/pubspec.yaml

# comment in if you need assets for working app
# ADD asset       /container/asset

# comment in if you need benchmarks to run pub build
# ADD benchmark   /container/benchmark

# comment in if you need docs to run pub build
# ADD doc         /container/doc

# comment in if you need examples to run pub build
# ADD example     /container/example

# comment in if you need test to run pub build
# ADD test        /container/test

# comment in if you need tool to run pub build      
# ADD tool        /container/tool

# comment in if you need lib to run pub build
# ADD lib         /container/lib

ADD bin          /container/bin       

# comment out if you do not need web for working app
ADD web          /container/web

# Build the app. Do not touch this.
WORKDIR /container
RUN pub build

# Expose port 8080. You should change it to the port(s) your app is serving on.
EXPOSE 8080

# Entrypoint. Whenever the container is started the following command is executed in your container.
# In most cases it simply starts your app.
WORKDIR /container/bin
ENTRYPOINT ["dart"]

# Change this to your starting dart.
CMD ["httpserver.dart"]
```

### Remarks regarding docker (on non linux systems)

If docker is used on a non linux system like Mac OS X it is likely that docker uses [VirtualBox][virtualbox] under the hood. In theses cases you must configure port forwarding in virtual box. So if you are exposing port 8080 in your docker container mapping it to port 8888 for the outside world you must forward host port 8888 to docker-vm port 8888 in virtualbox. How to do this is explained [here][virtualbox-portforward].

[docker]: https://www.docker.io/
[dart]: https://www.dartlang.org/
[start]: https://github.com/lvivski/start
[sinatra]: http://www.sinatrarb.com/
[virtualbox]: https://www.virtualbox.org/
[virtualbox-portforward]: http://www.virtualbox.org/manual/ch06.html#natforward
