# Rahona be Labs
# Dockerfile for an icingaweb2 system
# Contains code from
# https://github.com/jjethwa/icinga2
# and following https://github.com/Icinga/icingaweb2/blob/master/doc/20-Advanced-Topics.md#web-setup-automation

FROM debian:bullseye-slim

MAINTAINER Luigi - Rahona Labs

# First apt-get batch
RUN export DEBIAN_FRONTEND=noninteractive \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install -y --no-install-recommends \
	  apache2 \
          ca-certificates \
	  curl \
          gcc  \
	  gnupg2 \
	  graphviz \
	  iputils-ping \
          logrotate \
          mariadb-client \
          net-tools \
          ntp       \
	  php-cli \
	  php-gd \
	  php-intl \
          php-imagick \
          php-curl \
          php-ldap \
	  php-mysql \
	  php-sqlite3 \
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

# Second apt-get batch
RUN export DEBIAN_FRONTEND=noninteractive \
     && wget --quiet -O /tmp/icinga.key https://packages.icinga.com/icinga.key && apt-key add /tmp/icinga.key \
     && echo "deb http://packages.icinga.com/debian icinga-bullseye main" > /etc/apt/sources.list.d/icinga2.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          icingaweb2 \
          icingacli \
          	  rrdcached \
          bc               \
     icingaweb2-module-doc \
     icingaweb2-module-monitoring \
          && apt-get -y install rrdcached \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

RUN useradd nagios
RUN usermod -u 9001 nagios && groupmod -g 9001 nagios

ADD content/ /

# Get NAGVIS
RUN mkdir -p /tmp/nagvis \
    && wget -q --no-cookies -O - "https://github.com/nagvis/nagvis/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/tmp/nagvis -f - nagvis-master/ \
    && cd /tmp/nagvis \
    && ./install.sh -u www-data -g www-data -w /etc/apache2/sites-available -a y -q -F

# Get NAGVIS module
RUN mkdir -p /usr/share/icingaweb2/modules/nagvis \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-nagvis/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/nagvis -f - icingaweb2-module-nagvis-master/

# Get cube module
RUN mkdir -p /usr/share/icingaweb2/modules/cube \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-cube/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/cube -f - icingaweb2-module-cube-master/

# Get map module
RUN mkdir -p /usr/share/icingaweb2/modules/map \
    && wget -q --no-cookies -O - "https://github.com/nbuchwitz/icingaweb2-module-map/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/map -f - icingaweb2-module-map-master/

# Get company module
RUN mkdir -p /usr/share/icingaweb2/modules/company \
    && wget -q --no-cookies -O - "https://github.com/rahonalab/icingaweb2-theme-company/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/company -f - icingaweb2-theme-company-master/

# reactbundle
RUN mkdir -p /usr/share/icingaweb2/modules/reactbundle \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-reactbundle/archive/v0.9.0.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/reactbundle -f - icingaweb2-module-reactbundle-0.9.0/

# ipl
RUN mkdir -p /usr/share/icingaweb2/modules/ipl \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-ipl/archive/v0.5.0.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/ipl -f - icingaweb2-module-ipl-0.5.0/

# incubator
RUN mkdir -p /usr/share/icingaweb2/modules/incubator \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-incubator/archive/v0.7.0.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/incubator -f - icingaweb2-module-incubator-0.7.0/

# Get director module
RUN mkdir -p /usr/share/icingaweb2/modules/director \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-director/archive/master.tar.gz" \
    | tar vxz --strip-components=1 --directory=/usr/share/icingaweb2/modules/director -f - icingaweb2-module-director-master/

# Final fixes
RUN usermod -aG icingaweb2 www-data \
&& usermod -aG nagios www-data \
&& mv /etc/icingaweb2 /etc/icingaweb2.dist && mv /usr/share/icingaweb2 /usr/share/icingaweb2.dist && mv /usr/local/nagvis /usr/local/nagvis.dist
 
# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
