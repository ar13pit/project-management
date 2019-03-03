# ----------------------------------------------------------------
#       Dockerfile to build working Ubuntu image with tue-env
# ----------------------------------------------------------------

# Set the base image to Ubuntu 16.04
FROM ubuntu:16.04

# Inform scripts that no questions should be asked and set some environment
# variables to prevent warnings and errors
ENV DEBIAN_FRONTEND=noninteractive \
    CI=true
    LANG=C.UTF-8 \
    DOCKER=true \
    USER=amigo \
    TERM=xterm

# Set default shell to be bash
SHELL ["/bin/bash", "-c"]

# Install commands used in our scripts and standard present on a clean ubuntu
# installation and setup a user with sudo priviledges
RUN apt-get update -qq && \
    apt-get install -qq --assume-yes --no-install-recommends apt-transport-https apt-utils ca-certificates curl dbus dialog git lsb-release sudo wget && \
    # Add amigo user
    adduser --disabled-password --gecos "" $USER && \
    adduser $USER sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    # Install openproject
    wget -qO- https://dl.packager.io/srv/opf/openproject-ce/key | sudo apt-key add - && \
    wget -O /etc/apt/sources.list.d/openproject-ce.list \
        https://dl.packager.io/srv/opf/openproject-ce/stable/8/installer/ubuntu/16.04.repo && \
    apt-get update -qq && \
    apt-get install openproject


# Setup the current user and its home directory
USER "$USER"
WORKDIR /home/"$USER"
