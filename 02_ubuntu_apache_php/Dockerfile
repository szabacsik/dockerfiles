FROM ubuntu:xenial
LABEL maintainer "András Szabácsik <https://github.com/szabacsik>"
ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --assume-yes --no-install-recommends apt-utils && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
	apt-get install -y --assume-yes --no-install-recommends mc nano git curl net-tools htop screen byobu && \
	apt-get clean && \
	apt-get autoclean && \
	apt-get autoremove
ENV DEBIAN_FRONTEND=teletype
