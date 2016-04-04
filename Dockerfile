FROM ubuntu:16.04 
MAINTAINER Adam Crow <adamcrow63@gmail.com>

RUN echo "deb http://au.archive.ubuntu.com/ubuntu xenial main universe" > /etc/apt/sources.list

# Install necessary packages 
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends python-software-properties software-properties-common \
    && apt-get install --quiet --yes --no-install-recommends xmlstarlet libsaxonb-java libaugeas-dev augeas-tools bsdtar unzip \
    && apt-get install --quiet --yes --no-install-recommends curl wget maven libsystemd-journal0 \
    && apt-get clean

RUN add-apt-repository ppa:webupd8team/java -y

RUN apt-get update --quiet
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get install -y oracle-java8-installer
RUN update-alternatives --display java
RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# copy across useful jars
COPY java/* /usr/share/java/
RUN ln -s /usr/share/java/jaxp_transform_impl.jar -> /etc/alternatives/jaxp_transform_impl

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# Specify the user which should be used to execute all commands below
USER jboss


