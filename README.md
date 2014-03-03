Container Dart
==============

[docker]: https://www.docker.io/
[dart]: https://www.dartlang.org/
[start]: https://github.com/lvivski/start
[sinatra]: http://www.sinatrarb.com/

[Docker][docker] is an open-source engine that automates the deployment of applications as portable and self-sufficient containers that will run virtually anywhere. Dockerized applications reduce configuration efforts and obstacles for administrators. Applications can be provided in a configured, self-sufficient and frictionless way.

Container Dart shows how this can be accomplished for [Dart][dart] server applications.

Container Dart is just a simple HTML page which is be provided by a very simple [Dart][dart] HTTP server using the [Sinatra][sinatra] inspired web framework [Start][start].

```
import 'package:start/start.dart';

main() {
  start(port: 8080).then((Server app) {
    app.static('../build/web');
  });
}
```

This server is hosted in a docker image. This image is a Ubuntu 13.10 based docker image which beeing created by the following Dockerfile

```
# Install a dart container for demonstration purposes.
# Your dart server app will be accessible via HTTP on port 8080. The port can be changed.
# You should adapt this Dockerfile to your needs.
#
# This file is hosted on github. Therefore you can start it in docker like this:
# > docker build -t containerdart github.com/nkratzke/containerdart
# > docker run containerdart

FROM stackbrew/ubuntu:13.10
MAINTAINER Nane Kratzke <nane@nkode.io>

# Get the command apt-add-repository working. Needed to install Dart SDK.
# Do not touch this until you know what you are doing.
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties

# Install Dart SDK. Do not touch this until you know what you are doing.
# We do not install darteditor nor dartium because this is a server container.
# See: http://askubuntu.com/questions/377233/how-to-install-google-dart-in-ubuntu
RUN apt-add-repository ppa:hachre/dart
RUN apt-get -y update
RUN apt-get install -y dartsdk

# Install the dart server app. Do not touch this until you know what you are doing.
# Copy the bin and build directory to the container.
ADD pubspec.yaml /opt/containerdart/pubspec.yaml
ADD bin /opt/containerdart/bin
ADD build /opt/containerdart/build
# RUN cd /opt/containerdart
# RUN pub get
RUN pub build /opt/containerdart/

# Expose port 8080. You should change it to the port(s) your app is serving on.
EXPOSE 8080

# Entrypoint. Whenever the container is started the following command is executed in your container.
# In most cases it simply starts your app.
# You should change it to the dart file of your app.
ENTRYPOINT ["dart", "/opt/containerdart/bin/httpserver.dart"]
```

If you are on a system with installed docker you can run the following two commands to start a webserver on port 8080.

```
docker build -t containerdart github.com/nkratzke/containerdart
docker run -p 8080:8080 -d containerdart
```
