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
	  graphviz \
          logrotate \
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
	  php5-sqlite \
          procps \
          python \
          python-dev \
          pwgen \
	  rsync \
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

#Modify nagios uid to be consistent across containers
RUN usermod -u 9001 nagios && groupmod -g 9001 nagios

ADD content/ /

#Get PNP modules
RUN mkdir -p /usr/share/icingaweb2/modules/pnp \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-pnp/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/pnp -f - icingaweb2-module-pnp-master/

#Get NAGVIS
RUN mkdir -p /tmp/nagvis \
    && wget -q --no-cookies -O - "https://github.com/nagvis/nagvis/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/tmp/nagvis -f - nagvis-master/ \
    && cd /tmp/nagvis \
    && ./install.sh -u www-data -g www-data -w /etc/apache2/sites-available -a y -q -F

#Get NAGVIS module
RUN mkdir -p /usr/share/icingaweb2/modules/nagvis \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-nagvis/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/nagvis -f - icingaweb2-module-nagvis-master/

#Get cube module
RUN mkdir -p /usr/share/icingaweb2/modules/cube \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-cube/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/cube -f - icingaweb2-module-cube-master/

#Get map module
RUN mkdir -p /usr/share/icingaweb2/modules/map \
    && wget -q --no-cookies -O - "https://github.com/nbuchwitz/icingaweb2-module-map/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/map -f - icingaweb2-module-map-master/

#Final fixes
RUN usermod -aG icingaweb2 www-data \
&& usermod -aG nagios www-data \
&& mv /etc/icingaweb2 /etc/icingaweb2.dist && mv /etc/pnp4nagios /etc/pnp4nagios.dist && mv /usr/share/icingaweb2 /usr/share/icingaweb2.dist && mv /usr/local/nagvis /usr/local/nagvis.dist
 
# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
