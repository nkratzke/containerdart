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
RUN cd /opt/containerdart
# RUN pub get
RUN pub build

# Expose port 8080. You should change it to the port(s) your app is serving on.
EXPOSE 8080

# Entrypoint. Whenever the container is started the following command is executed in your container.
# In most cases it simply starts your app.
# You should change it to the dart file of your app.
ENTRYPOINT ["dart", "/opt/containerdart/bin/httpserver.dart"]