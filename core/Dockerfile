# Rahona be Labs
# Dockerfile for an icinga2 core system

# Contains code from
# https://github.com/jjethwa/icinga2

FROM debian:bullseye-slim

MAINTAINER Luigi - Rahona Labs

RUN rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          ca-certificates \
	  curl \
	  apt-utils \
          gcc  \
	  gnupg2 \
          liblist-compare-perl \
	  libclass-dbi-mysql-perl \
          libdbd-sybase-perl \
	  libmonitoring-plugin-perl \
	  liblwp-protocol-https-perl \
	  logrotate \
          mailutils \
          mariadb-client \
	  nagios-plugins-contrib \
          nagios-snmp-plugins \
          nagios-nrpe-plugin \
	  smbclient \
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

RUN export DEBIAN_FRONTEND=noninteractive \
     && wget --quiet -O /tmp/icinga.key https://packages.icinga.com/icinga.key && apt-key add /tmp/icinga.key \
     && echo "deb http://packages.icinga.com/debian icinga-bullseye main" > /etc/apt/sources.list.d/icinga2.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          icinga2 \
          icinga2-ido-mysql \
	  monitoring-plugins \
          bc               \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Modify nagios uid to be consistent across containers
RUN usermod -u 9001 nagios && groupmod -g 9001 nagios

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
