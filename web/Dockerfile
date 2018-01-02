#Rahona be Labs
# Dockerfile for an icingaweb2 system
#Contains code from
# https://github.com/jjethwa/icinga2
#and following https://github.com/Icinga/icingaweb2/blob/master/doc/20-Advanced-Topics.md#web-setup-automation

#Use debian:jessie
FROM debian:jessie-slim

MAINTAINER Luigi - Rahona Labs

#First apt-get batch
RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
          ca-certificates \
	  curl \
          gcc  \
	  gnupg2 \
          mysql-client \
          net-tools \
          ntp       \
	  php5-cli \
	  php5-gd \
	  php5-intl \
          php5-imagick \
          php5-curl \
          php5-ldap \
	  php5-mysql \
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

#Second apt-get batch
RUN export DEBIAN_FRONTEND=noninteractive \
     && wget --quiet -O - https://packages.icinga.org/icinga.key \
     | apt-key add - \
     && echo "deb http://packages.icinga.org/debian icinga-jessie main" > /etc/apt/sources.list.d/icinga2.list \
     && echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backport.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          icingaweb2 \
          icingacli \
          	  rrdcached \
          bc               \
     icingaweb2-module-doc \
     icingaweb2-module-monitoring \
          && apt-get -y -t jessie-backports install rrdcached \
	pnp4nagios \
          pnp4nagios-web \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

ADD content/ /

#Get PNP modules
RUN mkdir -p /usr/share/icingaweb2/modules/pnp \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-pnp/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/pnp -f - icingaweb2-module-pnp-master/

#Set permissions
RUN usermod -aG icingaweb2 www-data \
&& usermod -aG nagios www-data

RUN mv /etc/icingaweb2 /etc/icingaweb2.dist
 
# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
