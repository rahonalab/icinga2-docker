#Rahona be Labs
# Dockerfile for an icinga2 master system: no icingaweb2, no nagios plugins, no notification

#Contains code from
# https://github.com/jjethwa/icinga2

FROM debian:jessie

MAINTAINER Luigi - Rahona Labs

RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          curl \
          gcc  \
	  gnupg2 \
          mysql-client \
          mysql-server \
          net-tools \
          ntp       \
	  php5-cli \
	  php5-gd \
          php5-curl \
          php5-ldap \
          procps \
          python \
          python-dev \
          pwgen \
          snmp \
          libsnmp-base \
          tcpdump \
          sudo \
          supervisor \
          unzip \
          wget \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN echo Europe/Rome >/etc/timezone && \
dpkg-reconfigure -f noninteractive tzdata

RUN echo "deb http://http.debian.net/debian/ jessie main contrib non-free" > /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive \
     && wget --quiet -O - https://packages.icinga.org/icinga.key \
     | apt-key add - \
     && echo "deb http://packages.icinga.org/debian icinga-jessie main" > /etc/apt/sources.list.d/icinga2.list \
     && echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backport.list \
     && export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          icinga2 \
          icinga2-ido-mysql \
          icingacli \
          bc               \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
