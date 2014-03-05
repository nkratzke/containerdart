# Install a dart container for demonstration purposes.
# Your dart server app will be accessible via HTTP on container port 8080. The port can be changed.
# You should adapt this Dockerfile to your needs.
# If you are new to Docker please read http://docs.docker.io/en/latest/reference/builder/ to learn more about Dockerfiles.
#
# This file is hosted on github. Therefore you can start it in docker like this:
# > docker build -t containerdart github.com/nkratzke/containerdart
# > docker run -p 8080:8080 -d containerdart

FROM stackbrew/ubuntu:13.10
MAINTAINER Nane Kratzke <nane@nkode.io>

# Specifies where the dart app is installed. Modify to your needs.
ENV INSTALL_DIR /opt/dockers/containerdart

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
ADD pubspec.yaml $INSTALL_DIR/pubspec.yaml
# ADD asset       $INSTALL_DIR/asset     # comment in if you need assets for working app
# ADD benchmark   $INSTALL_DIR/benchmark # comment in if you need benchmarks to run pub build
# ADD doc         $INSTALL_DIR/doc       # comment in if you need docs to run pub build
# ADD example     $INSTALL_DIR/example   # comment in if you need examples to run pub build
# ADD test        $INSTALL_DIR/test      # comment in if you need test to run pub build
# ADD tool        $INSTALL_DIR/tool      # comment in if you need tool to run pub build
# ADD lib         $INSTALL_DIR/lib       # comment in if you need lib to run pub build
ADD bin          $INSTALL_DIR/bin        # likely that you need this every time
ADD web          $INSTALL_DIR/web        # comment in if you need web for working app
RUN cd $INSTALL_DIR; pub build

# Expose port 8080. You should change it to the port(s) your app is serving on.
EXPOSE 8080

# Entrypoint. Whenever the container is started the following command is executed in your container.
# In most cases it simply starts your app.
ENTRYPOINT ["dart"]
CMD ["$INSTALL_DIR/httpserver.dart"]     # Changes this to your application file