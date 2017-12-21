# Dockerfile for snmptrap
#contains code from
# https://github.com/jjethwa/icinga2

FROM debian:stretch-slim

MAINTAINER Luigi - Rahona Labs

RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          procps   \
          net-tools \
          ntp       \
          python \
          python-dev \
          pwgen \
          snmp \
          snmptrapd \
          libsnmp-base \
          libnet-snmp-perl \
          snmp-mibs-downloader \
          snmptt \
          supervisor \
          unzip \
          wget \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

ADD content/ /

# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
