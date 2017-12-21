#Rahona be Labs
# Dockerfile for an icinga2 core system

#Contains code from
# https://github.com/jjethwa/icinga2

FROM debian:stretch-slim

MAINTAINER Luigi - Rahona Labs

RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          ca-certificates \
	  curl \
          gcc  \
	  gnupg2 \
          mailutils \
          mysql-client \
          net-tools \
          ntp       \
          procps \
          python \
          python-dev \
          pwgen \
          snmp \
          libsnmp-base \
	  ssmtp		\
          tcpdump \
          sudo \
          supervisor \
          unzip \
          wget \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN echo Europe/Rome >/etc/timezone && \
dpkg-reconfigure -f noninteractive tzdata

RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive \
     && wget --quiet -O - https://packages.icinga.org/icinga.key \
     | apt-key add - \
     && echo "deb http://packages.icinga.org/debian icinga-stretch main" > /etc/apt/sources.list.d/icinga2.list \
     && echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backport.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          icinga2 \
          icinga2-ido-mysql \
	  monitoring-plugins \
          bc               \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

ADD content/ /

# Final fixes
RUN sed -i 's/vars\.os.*/vars.os = "Docker"/' /etc/icinga2/conf.d/hosts.conf \
    && mv /etc/icinga2/ /etc/icinga2.dist \
    && usermod -aG nagios www-data \
    && chmod u+s,g+s \
        /bin/ping \
        /bin/ping6 \
        /usr/lib/nagios/plugins/check_icmp
# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
